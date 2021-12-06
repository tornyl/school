
(defun plist-remove (plist prop)
	(cond ( (null plist) nil)
			( (eql (car plist) prop) (plist-remove (cddr plist) prop))
			( t (cons (car plist) (cons (cadr plist) (plist-remove (cddr plist) prop))))))


(defun plist-add (plist prop val)
	(cond ( (null plist) (list prop val))
			( (eql (car plist) prop) (cons prop (cons val (cddr plist))))
			( t (cons (car plist) (cons (cadr plist) (plist-add (cddr plist) prop val))))))



(defun point (x y)
	(list (cons 'x x) (cons 'y y)))

(defun point-x (pt)
	(cond ((null pt) nil)
			((eql (caar pt) 'x) (cdar pt))
			(t (point-x (cdr pt)))))


(defun point-y (pt)
	(cond ((null pt) nil)
			((eql (caar pt) 'y) (cdar pt))
			(t (point-y (cddr pt)))))


(defun alist-remove (alist prop)
	(cond ((null alist) nil)
			((eql (caar alist) prop) (alist-remove (cdr alist) prop))
			(t (cons (cons (caar alist) (cdar alist)) (alist-remove (cdr alist) prop)))))

(defun alist-add (alist prop val)
	(cond ((null alist) (list (cons prop val)))
			((eql (caar alist) prop) (cons (cons prop val) (cdr alist)))
			(t (cons (cons (caar alist) (cdar alist)) (alist-add (cdr alist) prop val)))))


(defun tree-node (val children)
	(cons val children))

(defun node-value (node)
	(car node))

(defun node-children (node)
	(cdr node))


;(tree-node 5 (list (tree-node 2 (list (tree-node 1 nil) (tree-node 3 (list (tree-node 4 nil))))) (tree-node 7 (list (tree-node 6 nil) (tree-node 8 nil)))))
(defun tree-values-dfs (val roots)
	(if (null roots)
		 '()
		(if (or (eql (tree-find val (car roots)) val) (eql (tree-values-dfs val (cdr roots)) val))
			 val
			nil)))

(defun tree-find (val tree)
	(cond ((null tree) nil)
			((eql (node-value tree) val) val)
			(t  (tree-values-dfs val (node-children tree)))))


(defun tree-sum-multi (roots)
	(if (null roots)
		 0
		(+ (tree-sum (car roots)) (tree-sum-multi (cdr roots)))))

(defun tree-sum (tree)
	(if (null tree)
		 0
		(+ (node-value tree) (tree-sum-multi (node-children tree)))))

; bfs try

(defun node-value-multi (nodes)
	(if (null nodes)
		 '()
		(cons (node-value (car nodes))
				(node-value-multi (cdr nodes)))))

(defun node-children-multi (nodes)
	(if (null nodes)
		 '()
		(append (node-children (car nodes))
				  (node-children-multi (cdr nodes)))))

(defun tree-maximal-paths-b (roots)
	(if (null roots)
		 nil
		(list (node-value-multi roots) (tree-maximal-paths-b (node-children-multi roots)))))
(defun tree-mp (tree)
	(tree-maximal-paths-b (list tree)))

; end

(defun tree-paths-v4 (tree)
	(tree-val-norm (car tree) (cdr tree)))

(defun tree-val-norm (anc tree)
	(if (null tree)
		 anc
		(cons (brah anc (car tree))
				  (tree-val-norm anc (node-children tree)))))

(defun brah (anc tree)
			(tree-val-norm (list anc (car tree)) (cdr tree)))


(defun tree-val-norm-multi (anc roots)
	(if (null roots)
		 anc
		(append (tree-val-norm anc (car roots)) (tree-val-norm-multi anc (cdr roots)))))


(defun tree-paths-v3 (tree)
	(tree-path-val-v3 (node-value tree) (node-children tree)))

(defun tree-path-val-v3 (ancestor root)
	(if (null root)
		 nil
		(list (list ancestor (node-value (car root))) (tree-path-val-v3 ancestor (cdr root)))))


;(defun tree-paths-v3-val (root)
	
;(defun tree-path-get-val-v3 (ancestor root)
	
(defun tree-paths-v5 (tree)
	(tree-vn5 (car tree) (cdr tree)))

(defun tree-vn5 (anc tree)
	(if (null tree)
		 anc
		(cons (tree-vn5 (list anc (caar tree)) (cdar tree))
				  (tree-vn5 anc (node-children tree)))))



(defun tree-height (tree)
	(tree-height-a tree 1))

(defun tree-height-a (tree maxx)
	(cond ( (null tree) nil)
			( (consp (car tree)) (append (tree-height-a (car tree) (+ maxx 1)) (tree-height-a (cdr tree) (+ maxx 1)))) 
			( t (cons maxx (tree-height-a (node-children tree) (+ maxx 1))))))

