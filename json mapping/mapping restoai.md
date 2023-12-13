Below you can find the mapping table  of the xml nodes   
some nodes meet more than once by our side   
# 

  
## Github issue : ours 


### parent nodes     
author       : name
author_ids   : codes
keywords     : keywords
review       : reviewer 
serial       : publisher , title 
references   : _text , _msc , _doucment_id , 
classifications: msc
document_id  : zbmath_id 

document_title : title
document_type: not found 
doi          : identifier  
language     : language 
publication_year: _year
source       : _source
spelling     : _name
zbl_id       :  not found 
serial       :  _publisher
serial       : _title
rights       : no rights node 
pagination   : _pages 
publication_year : _year  
links        : links ( empty) url is missing     
rights       : missing 


we have in some sections
Parent nodes from our code , which they are actually child nodes in the github issue .

publisher is parent node , which it suits the child node from
the serial node
_title is also the same which it suits the title in the serial parent node

in references and review parent nodes we have also some the same   


Missing nodes are : links , rights  
  
the first node is ours and the response represents the  node of the github issue.   

below you can see an instance about some complexity with the nodes    
this is the review parent node with its child nodes  
  
              <zbmath:review>
              <zbmath:review_language>English</zbmath:review_language>
              <zbmath:review_sign>Jonas Šiaulys (Vilnius)</zbmath:review_sign>  // chk 
              <zbmath:review_text>The prime \(k\)-tuples and small gaps between prime numbers are considered. Using a refinement of the Goldston-Pintz-Yildirim sieve method [\textit{D. A. Goldston} et al., Ann. Math. (2) 170, No. 2, 819--862 (2009; Zbl 1207.11096)] the author proves, for instance, the following estimates 
              \[

             \liminf_{n\to\infty}\,(p_{n+m}-p_n)\ll m^3\text{{e}}^{4m}, \quad \liminf_{n\to\infty}\,(p_{n+1}-p_n)\leq 600

             \]
             with an absolute constant in sign \(\ll\). Here \(m\) is a natural number, and \(p_{\,l}\) denote the \(l\)-th prime number.</zbmath:review_text> // chk 
              <zbmath:review_type>review</zbmath:review_type>  // chk 
              <zbmath:reviewer>11807</zbmath:reviewer>   // chk
              <zbmath:reviewer_id>siaulys.jonas</zbmath:reviewer_id>  // chk 
             </zbmath:review> 
            
              
        and our response was in this form as separated parent nodes with matching values   
  

       <zbmath:_author_code>siaulys.jonas</zbmath:_author_code>
    	<zbmath:_reviewer_id>11807</zbmath:_reviewer_id>
    	<zbmath:_name>Jonas Šiaulys</zbmath:_name>
	     <zbmath:_sign>Jonas Šiaulys (Vilnius)</zbmath:_sign>
    	<zbmath:_text>The prime \(k\)-tuples and small gaps between prime numbers are considered. Using a refinement of the Goldston-Pintz-Yildirim sieve method [\textit{D. A. Goldston} et al., Ann. Math. (2) 170, No. 2, 819--862 (2009; Zbl 1207.11096)] the author proves, for instance, the following estimates 
      \[
      \liminf_{n\to\infty}\,(p_{n+m}-p_n)\ll m^3\text{{e}}^{4m}, \quad \liminf_{n\to\infty}\,(p_{n+1}-p_n)\leq 600
      \]
     with an absolute constant in sign \(\ll\). Here \(m\) is a natural number, and \(p_{\,l}\) denote the \(l\)-th prime number.</zbmath:_text>
	  <zbmath:_contribution_type>review</zbmath:_contribution_type>     
  
     for further information and questions  dont hesitate to contact me 
	
	
	
	