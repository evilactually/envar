#include <windows.h>
#include <stdio.h>

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

    RegCloseKey(hKey);

    return value_buf;
};

char** winapi_get_var_names(int scope)
{
    HKEY hKey;
    LONG lRet = open_variables_key(scope, &hKey);

    DWORD var_count = 0;
    DWORD longest_value = 0;

    RegQueryInfoKey(hKey,     
                    NULL,     
                    NULL,     
                    NULL,     
                    NULL,     
                    NULL,     
                    NULL,     
                    &var_count,                 
                    &longest_value,     
                    NULL,     
                    NULL,     
                    NULL);
    char** name_list = malloc (sizeof(char*)*(var_count + 1));
    name_list[var_count] = NULL;                     // scheme expects NULL terminated list

    char name_buffer [sizeof(char)*(longest_value)];

    int i = 0;
    for (i = 0; i < var_count; i++)
    {
        DWORD size = sizeof(name_buffer);
        RegEnumValue(hKey,   
                     i,      
                     name_buffer,                 
                     &size,                          // not including the terminating null character                        
                     0,
                     NULL,
                     NULL,
                     NULL);
        name_list[i] = malloc(size+1);               // + 1 for null terminator
        memcpy(name_list[i], name_buffer, size + 1); // copy string + null terminator
    };

    return name_list;
};


    
