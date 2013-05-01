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

LONG open_variables_key(int scope, HKEY* key_out)
{
    return RegOpenKeyEx(scope == SYSTEM_SCOPE ? SYSTEM_ROOTKEY : USER_ROOTKEY,
                        scope == SYSTEM_SCOPE ? SYSTEM_SUBKEY : USER_SUBKEY,    
                        0,                           
                        KEY_ALL_ACCESS,            
                        key_out);  
}

int get_value_length(HKEY hKey, char* name)
{
    DWORD value_size = 0;
    RegQueryValueEx (hKey,                     
                     name,                     
                     0,
                     NULL,                     
                     NULL,            
                     &value_size              
                );
    return value_size;
}

char* winapi_read_var(int scope, char* name)
{
    HKEY hKey;
    DWORD buffer_size = get_value_length(hKey, name);

    LONG lRet = open_variables_key(scope, &hKey);
    char* value_buf = malloc(buffer_size);
    value_buf[0]=0;

    RegQueryValueEx(hKey,                     
                    name,                     
                    0,
                    NULL,                     
                    value_buf,            
                    &buffer_size);

    return value_buf;
};

