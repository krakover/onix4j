package org.onix4j.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;import java.lang.String;import java.lang.StringBuilder;

/**
 * User: Neta
 * Date: 5/22/14
 * Time: 3:28 PM
 */
public class FileUtils {
    public static String readFile(String fileName) throws IOException {
        StringBuilder sb = new StringBuilder();

        final BufferedReader bufferedReader = new BufferedReader(new FileReader(fileName));
        String line = bufferedReader.readLine();
        while (line != null) {
            sb.append(line).append("\n");
            line =  bufferedReader.readLine();
        }

        return sb.toString();
    }

}
