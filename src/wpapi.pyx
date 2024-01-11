import pickle
import base64
import requests

class WpApi:
    def __init__(self):
        self.reset_post()
        self.host = "127.0.0.1"
        self.enc_head = None

    def save_to_file(self, file_path):
        with open(file_path, 'wb') as file:
            pickle.dump(self, file)
            print(f"WpApi object serialized and saved to: {file_path}")

    @staticmethod
    def load_from_file(file_path):
        try:
            with open(file_path, 'rb') as file:
                return pickle.load(file)
        except FileNotFoundError:
            print("File not found or couldn't be loaded.")
            return None

    def easey_encrypt(self, ip):
        b64encoded = base64.b64encode(ip.encode('utf-8')).decode('utf-8')

        # Reverse the string
        reverse = b64encoded[::-1]
        tmp = []
        OFFSET = 4
        for char in reverse:
            tmp.append(chr(ord(char) + OFFSET))
        return ''.join(tmp)

    def easey_decrypt(self, secret):
        tmp = []
        OFFSET = 4
        for char in secret:
            tmp.append(chr(ord(char) - OFFSET))
        reversed_str = ''.join(tmp)[::-1]
        return base64.b64decode(reversed_str).decode('utf-8')

    def reset_post(self):
        self.post_id = ''
        self.post_date = ''
        self.post_status = ''
        self.post_author = ''
        self.post_categories = []
        self.post_tags = []
        self.response_text = ''

    def reset_status_code(self):
        self.status_code=0
        
    def reset_wp_categories(self):
        self.wp_categories = {}

    def reset_wp_tags(self):
        self.wp_tags = {}

    def get_categories(self):
        try:
            self.reset_wp_categories()
            self.reset_status_code()
            self.set_urls()
            response = requests.get(self.wp_categories_url)
            self.status_code = response.status_code
            if self.status_code==200:
                api_response = response.json()
                for t in api_response:
                    self.wp_categories[t['name'].lower()]=t['id']
                self.response_text = response.text
            return response.text
        except requests.exceptions.RequestException as e:
            return f"Error making HTTP request: {str(e)}"
            
    def get_tags(self):
        try:
            self.reset_wp_tags()
            self.reset_status_code()
            self.set_urls()
            response = requests.get(self.wp_tags_url)
            self.status_code = response.status_code
            if self.status_code==200:
                api_response = response.json()
                for t in api_response:
                    self.wp_tags[t['name'].lower()]=t['id']
                self.response_text = response.text
            return response.text
        except requests.exceptions.RequestException as e:
            return f"Error making HTTP request: {str(e)}"

    def parse_categories(self, categories):
        self.wp_category_ids=[]
        if ',' in categories:
            for t in categories.split(','):
                u=t.strip().lower()
                if u in self.wp_categories:
                    self.wp_category_ids.append(self.wp_categories[u])
        else:
            u=categories.strip().lower()
            if u in self.wp_categories:
                self.wp_category_ids.append(self.wp_categories[u])
        return self.wp_category_ids
        
    def parse_tags(self, tags):
        self.wp_tag_ids=[]
        if ',' in tags:
            for t in tags.split(','):
                u=t.strip().lower()
                if u in self.wp_tags:
                    self.wp_tag_ids.append(self.wp_tags[u])
        else:
            u=tags.strip().lower()
            if u in self.wp_tags:
                self.wp_tag_ids.append(self.wp_tags[u])
        return self.wp_tag_ids
    
    def post_post(self, article_title, article_body, post_status="draft", featured_media_id=0, categories=None, tags=None):
        try:
            headers = {'Authorization': self.easey_decrypt(self.enc_head)}
            if tags is None:
                if hasattr(self,'wp_tag_ids') and len(self.wp_tag_ids) > 0:
                    tags=self.wp_tag_ids
                else:
                    tags=[]
            if categories is None:
                if hasattr(self,'wp_category_ids') and len(self.wp_category_ids) > 0:
                    categories=self.wp_category_ids
                else:
                    categories=[1]
            post_data = {
                "title": article_title,
                "content": article_body,
                "comment_status": "closed",
                "categories": categories,
                "status": post_status,
                "tags": tags,
                "featured_media": featured_media_id
            }
            self.reset_post()
            self.reset_status_code()
            self.set_urls()
            response = requests.post(self.wp_post_url, headers=headers, json=post_data)
            self.status_code = response.status_code
            if self.status_code==201:
                api_response = response.json()
                self.post_id = api_response.get('id')
                self.post_date = api_response.get('date')
                self.post_status = api_response.get('status')
                self.post_author = api_response.get('author')
                self.post_categories = api_response.get('categories')
                self.post_tags = api_response.get('tags')
                self.response_text = response.text
            return response.text
        except requests.exceptions.RequestException as e:
            return f"Error making HTTP request: {str(e)}"

    def set_urls(self):
        self.wp_url = f"http://{self.host}/wp-json/wp/v2"
        self.wp_post_url = f"{self.wp_url}/posts"
        self.wp_media_url = f"{self.wp_url}/media"
        self.wp_tags_url = f"{self.wp_url}/tags"
        self.wp_categories_url = f"{self.wp_url}/categories"
        
    def set_credentials(self, username, user_app_password):
        credentials = f"{username}:{user_app_password}"
        self.enc_head = self.easey_encrypt(f"Basic {base64.b64encode(credentials.encode('utf-8')).decode('utf-8')}")