    ### eval.coffee ###

    evaluate = (m, roots) ->
        els = []

        if roots.length
            switch m.type 
                when ' ', '>'
                    # We don't need to search descendents of other roots...
                    outerRoots = subsume(roots)
                    els = find(outerRoots, m)
                
                    if m.type == '>'
                        els = els.filter (el) ->
                            el and (parent = el.parentNode) and roots.some((root) -> parent == root)
            
                    if m.not
                        els = sel.difference(els, find(roots, m.not))
            
                    if m.child
                        els = evaluate(m.child, els)

                when '+', '~', ','
                    sibs = evaluate(m.children[0], roots)
                    els = evaluate(m.children[1], roots)
            
                    if m.type == ','
                        els = sel.union(els, sibs)
                    
                    else if m.type == '+'
                        sibs = sibs.map((el) -> nextElementSibling(el))
                        sibs.sort(elCmp)
                        els = sel.intersection(els, sibs)
                    
                    else if m.type == '~'
                        els = els.filter (el) ->
                            el and (parent = el.parentNode) and sibs.some (sib) ->
                                sib != el and sib.parentNode == parent and elCmp(sib, el) == -1
                
        return els

