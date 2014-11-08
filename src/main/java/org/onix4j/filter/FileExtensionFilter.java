package org.onix4j.filter;

import org.onix4j.model.Onix;

import java.util.Arrays;
import java.util.List;

/**
 * User: Neta
 * Date: 6/3/14
 * Time: 12:03 PM
 */
public class FileExtensionFilter implements Filter {
    private List<String> extensions;
    public FileExtensionFilter() {
        extensions = Arrays.asList("xml", "onx", "o4j");
    }

    public FileExtensionFilter(List<String> extensions) {
        this.extensions = extensions;
    }

    public boolean useFile(String fileName) {
        return extensions.contains(fileName.substring(fileName.lastIndexOf(".")+1));
    }

    public boolean useOnix(Onix onix) {
        return true;
    }

    public boolean useProduct(String fileName, String uniqueIdentifier) {
        return true;
    }
}
