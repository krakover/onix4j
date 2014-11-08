package org.onix4j.util;

import java.lang.reflect.*;
import java.util.List;

/**
 * User: Neta Krakover
 * Date: 5/20/14
 */
public class ReflectionUtils {
    /**
     * Invoke the given callback on all fields in the target class,
     * going up the class hierarchy to get all declared fields.
     *
     * @param targetClass the target class to analyze
     * @param fc          the callback to invoke for each field
     * @param ff          the filter that determines the fields to apply the callback to
     */
    public static void doWithFields(Class targetClass, FieldCallback fc, FieldFilter ff)
            throws IllegalArgumentException {

        // Keep backing up the inheritance hierarchy.
        do {
            // Copy each field declared on this class unless it's static or file.
            Field[] fields = targetClass.getDeclaredFields();
            for (Field field : fields) {
                // Skip static and final fields.
                if (ff != null && !ff.matches(field)) {
                    continue;
                }
                try {
                    fc.doWith(field);
                } catch (IllegalAccessException ex) {
                    throw new IllegalStateException(
                            "Shouldn't be illegal to access field '" + field.getName() + "': " + ex);
                }
            }
            targetClass = targetClass.getSuperclass();
        }
        while (targetClass != null && targetClass != Object.class);
    }


    /**
     * Callback interface invoked on each field in the hierarchy.
     */
    public static interface FieldCallback {
        /**
         * Perform an operation using the given field.
         *
         * @param field the field to operate on
         */
        void doWith(Field field) throws IllegalArgumentException, IllegalAccessException;
    }

    /**
     * Callback optionally used to filter fields to be operated on by a field callback.
     */
    public static interface FieldFilter {

        /**
         * Determine whether the given field matches.
         *
         * @param field the field to check
         */
        boolean matches(Field field);
    }

    /**
     *
     */
    public static Object getValue(Field field, Object object) {
        try {
            field.setAccessible(true);
            return field.get(object);
        } catch (IllegalAccessException e) {
            return null;
        }
    }

    /**
     *
     */
    public static Class<?> getListGenericType(Field listField) {
        if (listField.getType().isAssignableFrom(List.class)) {
            ParameterizedType genericType = (ParameterizedType) listField.getGenericType();
            return (Class<?>) genericType.getActualTypeArguments()[0];
        }
        throw new IllegalArgumentException("given field is not from list type");
    }
}
