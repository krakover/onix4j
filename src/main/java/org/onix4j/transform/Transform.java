package org.onix4j.transform;

/**
 * User: Neta
 * Date: 6/3/14
 * Time: 12:10 PM
 */
public interface Transform<S,T> {
    public T transform(S file, boolean lazy);
}
