" if exists("b:current_syntax")
" 	finish
" endif

syntax region a_block start='(' end=')' fold transparent nextgroup=a_block,k_special,k_text skipempty skipwhite

syntax region v_list start='(' end=')' contained contains=a_block,v_date,v_heredoc,v_id,v_number,v_quoted,v_text fold transparent nextgroup=a_block,k_special,k_text skipempty skipwhite

" syntax match v_quoted '"[^"]\+"'
syntax region v_quoted start='"' end='"' matchgroup=quote nextgroup=a_block,k_special,k_text oneline skipempty skipwhite

" syntax region v_heredoc start='<<\(.\+\)' end='\1' concealends fold skipnl skipwhite
syntax region v_heredoc start='<<END' end='END' matchgroup=quote concealends fold skipempty skipwhite

" syntax match v_text '[^ ]\+' nextgroup=a_block,k_special,k_text

" syntax match k_text '[^ ]\+' nextgroup=v_date,v_id,v_list,v_number,v_text

syntax match v_id '@[^ ]\+' nextgroup=a_block,k_special,k_text

syntax match v_number '\d\+' nextgroup=a_block,k_special,k_text

syntax match v_date '\d\{4\}-\d\{2\}-\d\{2\}' nextgroup=a_block,k_special,k_text

syntax match v_datetime '\d\{4\}-\d\{2\}-\d\{2\}T\d\{4\}' nextgroup=a_block,k_special,k_text

syntax match v_url 'http[^ ]\+' nextgroup=a_block,k_special,k_text

syntax keyword k_special act date note start stop

" highlight default link a_block Error

highlight default link k_special Special
highlight default link k_text Identifier

highlight default link v_date Number
highlight default link v_datetime Number
highlight default link v_heredoc String
highlight default link v_id Identifier
" highlight default link v_list Error
highlight default link v_number Number
highlight default link v_quoted String
highlight default link v_text String
highlight default link v_url String
