package org.onix4j.metadata;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * User: Neta Krakover
 * Date: 5/20/14
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface Column {
    public String columnName() default "";
    public int instances() default 1;
    public String elementName() default "";
}
