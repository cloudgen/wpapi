# wpapi 

This is a program which tries to create a tools for wordpress api. 

# Compilation
Please use the following command for compilation of the lib file (src/wpapi.pyx) into build/lib/wpapi.cython-310-x86_64-linux-gnu.so (filename may be different due to version of python, version of gnu c and cpu architecture.) In side the project's folder, type the following in terminal:

```
./cy-master
```

The program should ask you following questions (depends on your system):
```
 A. Only python3 has been found!
  B. What do you want to:
    1) compile binary
    2) compile static library (.so) 
    Which option 1 or 2 (type "exit" to exit)?
```

Type 2 for static library. Then, the following question will be prompted:

```
Do you wanted to copy folder "build/lib" to folder "src" (yes/no)?
```
Type yes, then,
The file from build/lib/wpapi.cython-310-x86_64-linux-gnu.so copied to src/lib/wpapi.cython-310-x86_64-linux-gnu.so 
There is an empty file called src/lib/__init__.py

# Verification
```
cd src
python3
```
The inside the python3 interactive mode, type the following import command:
```
import lib.wpapi
dir(lib.wpapi)
```

You can see the following result.
```
['WpApi', '__builtins__', '__doc__', '__file__', '__loader__', '__name__', '__package__', '__spec__', '__test__', 'base64', 'pickle', 'requests']

```

# Setting chatgptapi 
You needed to collect the followings from wordpress's api page:
 * username
 * user application password

Inside the project folder, type the following command in terminal.
```
python3 src/main.py setauth
```
The enter the data in the following questions and obtain the corresponding response:
```
Enter username: [username]
Enter User App Password: [user-app-password]
WpApi object serialized and saved to: wpapi.data
```

# Running the api
Inside the project folder, type the following command in terminal.
```
python3 src/main.py post
```
You can find a new post created in localhost.
