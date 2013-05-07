#include <windows.h>
#include <stdio.h>

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

DWORD get_value_length(HKEY hKey, char* name)
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

DWORD get_longest_value(HKEY hKey)
{
    DWORD longest_value = 0;
    RegQueryInfoKey(hKey,     
                    NULL,     
                    NULL,     
                    NULL,     
                    NULL,     
                    NULL,     
                    NULL,     
                    NULL,                 
                    NULL,     
                    &longest_value,     
                    NULL,     
                    NULL);

    return longest_value;
}

DWORD get_longest_name(HKEY hKey)
{
    DWORD longest_name = 0;
    RegQueryInfoKey(hKey,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    &longest_name,
                    NULL,
                    NULL,
                    NULL);

    return longest_name;
}

void winapi_write_var(int scope, char* name, char* value)
{
    HKEY hKey;
    LONG lRet = open_variables_key(scope, &hKey);
        
    RegSetValueEx(hKey,
                  name,
                  0,
                  REG_SZ, // null terminated string
                  value,
                  sizeof(char)*(strlen(value) + 1));
    RegCloseKey(hKey);
}

char* winapi_read_var(int scope, char* name)
{
    HKEY hKey;
    int lRet = open_variables_key(scope, &hKey);
    
    DWORD buffer_size = get_value_length(hKey, name);
    
    char* value_buf = malloc(buffer_size);
    value_buf[0]=0;                         // null terminate in case query 
                                            // doesn't return anything
    RegQueryValueEx(hKey,                     
                    name,                     
                    0,
                    NULL,                     
                    value_buf,            
                    &buffer_size);

    RegCloseKey(hKey);
    
    return value_buf;
};

BOOL winapi_var_exists(int scope, char* name)
{
    HKEY hKey;
    int lRet = open_variables_key(scope, &hKey);
           
    lRet = RegQueryValueEx(hKey,                     
                           name,                     
                           0,
                           NULL,                     
                           NULL,            
                           NULL);

    RegCloseKey(hKey);
    
    return lRet == ERROR_SUCCESS;
};

void winapi_remove_var(int scope, char* name)
{
    HKEY hKey;
    LONG lRet = open_variables_key(scope, &hKey);
    RegDeleteValue(hKey, name);
    RegCloseKey(hKey);
};

// @descr: return total number of vars in both scopes
int winapi_var_count_all(void)
{
    return winapi_var_count_scope(SYSTEM_SCOPE) +
           winapi_var_count_scope(USER_SCOPE);
};

// @descr: return number of vars in a scope (user or system)
int winapi_var_count_scope(int scope)
{
    HKEY hKey;
    LONG lRet = open_variables_key(scope, &hKey);

    DWORD var_count = 0;
    DWORD longest_name = 0;
    DWORD longest_value = 0;

    RegQueryInfoKey(hKey,     
                    NULL,     
                    NULL,     
                    NULL,     
                    NULL,     
                    NULL,     
                    NULL,     
                    &var_count,                 
                    NULL,     
                    NULL,     
                    NULL,     
                    NULL);
    return var_count;
};

// @descr: enumerates all variables(user and system) by index
//       USER SCOPE: [0 .. user var count - 1]
//     SYSTEM SCOPE: [user var count .. system var count - 1]
BOOL winapi_read_by_index(int index, int* out_scope, char** out_name, char** out_value)
{
    /// vars ///
    HKEY hKey;

    int current_scope = -1;    

    /// decide which scope index belongs to              ///
    /// and open key containing the requested variable   ///

    int user_scope_var_count = winapi_var_count_scope(USER_SCOPE);
        
    if (index >= user_scope_var_count)                  // system range 
    {
        index = index - user_scope_var_count;           // convert index to system range
        if (index >= winapi_var_count_scope(SYSTEM_SCOPE))
            return FALSE;                               // out of range -> fail
        open_variables_key(SYSTEM_SCOPE, &hKey);
        current_scope = SYSTEM_SCOPE;
    } else if (index >= 0)                              // user range
    {                                                   // index doesn't need adjustment
        open_variables_key(USER_SCOPE, &hKey);
        current_scope = USER_SCOPE;
    } else
    {
        return FALSE;                                   // out of range -> fail
    }

    // allocate temp buffers on stack for name and value
    char name_buffer  [sizeof(char)*(get_longest_name(hKey))];
    char value_buffer [sizeof(char)*(get_longest_value(hKey))];

    // buffer size / bytes copied to buffer
    DWORD in_out_name_size = sizeof(name_buffer);
    DWORD in_out_value_size = sizeof(value_buffer);
    
    /// retrieve name and value into buffers ///
    RegEnumValue(hKey,
                 index,
                 name_buffer,
                 &in_out_name_size,                     // size not including the terminating 0
                 0,
                 NULL,
                 value_buffer,
                 &in_out_value_size);                   // likewise
    
    RegCloseKey(hKey);
    
    /// allocate and copy to new heap buffers, return them through output arguments ///
    *out_name = malloc(in_out_name_size + 1);              // + 1 for null terminator
    memcpy(*out_name, name_buffer, in_out_name_size + 1);  // copy string + null terminator
    *out_value = malloc(in_out_value_size+1);                        
    memcpy(*out_value, value_buffer, in_out_value_size + 1);
    *out_scope = current_scope;                            

    return TRUE;
};

char* winapi_expand_vars_in_string(const char* string_in)
{
    int const BUFFER_SIZE = 256;
    
    char* string_out = malloc(sizeof(char)*BUFFER_SIZE);
    int iRet = ExpandEnvironmentStrings(string_in,
                             string_out,
                             sizeof(char)*BUFFER_SIZE);
    
    return string_out;
}
