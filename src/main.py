from lib.wpapi import WpApi

if __name__ == "__main__":
    import sys

    if len(sys.argv) > 1:
        if sys.argv[1] == "setauth":
            username = input("Enter username: ")
            user_app_password = input("Enter User App Password: ")
            wp_api = WpApi()
            wp_api.set_credentials(username, user_app_password)
            wp_api.save_to_file("wpapi.data")
        elif sys.argv[1] == "post":
            wp_api = WpApi.load_from_file("wpapi.data")
            if wp_api and wp_api.enc_head:
                # Modify these parameters as needed for your post
                article_title = "Test post"
                article_body = "This is an automated post using WpApi."
                if len(sys.argv) > 3:
                    wp_api.get_tags()
                    wp_api.parse_tags(sys.argv[3])
                if len(sys.argv) > 2:
                    wp_api.get_categories()
                    wp_api.parse_categories(sys.argv[2])
                wp_api.post_post(article_title, article_body)
                print(f"Post_ID: {wp_api.post_id}")
            else:
                print("Could not load WpApi object from file.")
        elif sys.argv[1] == "tags":
            wp_api = WpApi()
            result=wp_api.get_tags()
            print(f"Response from WordPress: {wp_api.wp_tags}")
        elif sys.argv[1] == "categories":
            wp_api = WpApi()
            result=wp_api.get_categories()
            print(f"Response from WordPress: {wp_api.wp_categories}")
    else:
        print("Usage: python setup.py [setauth | categories | post | tags]")