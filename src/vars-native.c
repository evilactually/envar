#include <windows.h>

char* getstr(char* name)
{
	return "DIMOND";
};

#define SYSTEM_SUBKEY "SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment"
#define USER_SUBKEY  "Environment"
#define SYSTEM_ROOTKEY HKEY_LOCAL_MACHINE
#define USER_ROOTKEY HKEY_CURRENT_USER
#define SYSTEM_SCOPE 1
#define USER_SCOPE 2

char string_buffer[1024];

LONG open_variables_key(int scope, HKEY* key_out)
{
    return RegOpenKeyEx(scope == SYSTEM_SCOPE ? SYSTEM_ROOTKEY : USER_ROOTKEY,
                        scope == SYSTEM_SCOPE ? SYSTEM_SUBKEY : USER_SUBKEY,    
                        0,                           
                        KEY_ALL_ACCESS,            
                        key_out);  
}

char* winapi_read_var(int scope, char* name)
{
    HKEY hKey;
    DWORD buffer_size = sizeof(string_buffer);

    LONG lRet = open_variables_key(scope, &hKey);

    RegQueryValueEx (
    	    	hKey,                     
    	        name,                     
    	        0,
    	        NULL,                     
    	        string_buffer,            
    	        &buffer_size              
            );

    return string_buffer;
};