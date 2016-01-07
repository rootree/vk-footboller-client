<?php 

$doc = new DOMDocument();
$doc->load( 'resconfig.xml' );

$books = $doc->getElementsByTagName( "resource" );
foreach( $books as $book ){

	$src = $book->getAttribute('src');
	if(empty($src)){
		continue;	
	}
	
	$root_attr1 = $doc->createAttribute('lastupdate'); 
	$root_attr1->value = filemtime($src);
    $book->appendChild($root_attr1); 
	
	echo " -- " .$src . "--- \n\n";
}

$books = $doc->getElementsByTagName( "library" );
foreach( $books as $book ){

	$src = $book->getAttribute('path');
	if(empty($src)){
		continue;	
	}
	
	$root_attr1 = $doc->createAttribute('lastupdate'); 
	$root_attr1->value = filemtime($src);
    $book->appendChild($root_attr1); 
	
	echo " -- " .$src . "--- \n\n";
}
 
$doc->save("resconfig.xml")
 
?>