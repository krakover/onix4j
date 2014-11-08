Onix4j
======

Lightweight Java Library for ONIX files
---------------------------------------

The purpose of this package is to provide
simple lightweight tools for Onix manipulation.

### The package includes:
> ## Onix transformation to marc21xml format
> An updated, reality checked version for the mapping
> found here: http://www.loc.gov/marc/onix2marc.html.
> It is also possible to enhance the MARC records with additional information like the URL
> cover or subject heading, by implementing the EnhancedProduct methods.
>
> ## Transformation to basic product
> A transformation for mapping the onix to a java object,
> with a subset of the fields.
> A lightweight version of http://github.com/zach-m/Jonix
> In order to create your own mapping -
> 1. Add a new transformation, or change the existing onix2basicProduct.xsl, and
> 2. Add a new product object implementing IOnixProdcut, or change existing BasicProduct
> 3. Add your mapping file and class to xsltFiles of Onix2BasicProductsXML.
> 4. Change the EnhancedProduct file to retrieve the proper values from your system
> You are done.
> You can now use your product, as well as exporting it using any of the exporters.