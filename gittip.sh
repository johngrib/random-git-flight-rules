function git-flight-rules() {

    _fileName='/tmp/git-flight-rules.html'
    _indexFile='/tmp/git-flight-rules-index.txt'
    curl -s https://github.com/k88hudson/git-flight-rules/blob/master/README_kr.md > $_fileName

    _line=`grep '<h3' $_fileName -n | cut -d: -f1 | tee $_indexFile | sort -R | head -1`

    _anchor=`grep $_line $_indexFile -B 1`
    _start=$((`echo $_anchor | cut -d' ' -f1`))
    _end=$((`echo $_anchor | cut -d' ' -f2` - 1))
    _size=$(($_end - $_start + 1))

    _h2=`head -$_end $_fileName | tail -$_size | grep -En '<h2>' | cut -d: -f1`

    if [ "$_h2" = '' ]; then
        head -$_end $_fileName \
            | tail -$_size \
            | sed -Ee '
s,<svg.+</svg>,,;
s,<a.+</a>,,;
s,</?h3>, \
,g;
s,</?p>, \
,g;
s,</?div[^>]*>,,g;
s,&gt,>,g;
s,&lt,<,g;
s,</?[a-z]+>,,g;
s,</?span[^>]*>,,g;
'
    else
        echo '##recur##'
        git-flight-rules
    fi
}
