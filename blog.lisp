(require 'cl-fad)

(defun header ()
       "<html>
         <title>Blag</title>
  	 <body>")

(defun content (title content)
       (format nil "<h1>~a</h1><div class=\"content\">~a</div>" title content))

(defun nextp (id)
  nil)
(defun prevp (id)
  nil)

(defun navigation (id)
  (let* ((next (when (nextp id)
		(+ id 1)))
	(prev (when (prevp id)
		(- id 1)))
	(nav (format nil "<div class=\"navigation\">~a ~a</div>"
		     (if prev
			 (format nil "<div class=\"previous\"><a href=\"~a.html\">Previous</a></div>" prev)
		       "")
		     (if next
			 (format nil "<div class=\"next\"><a href=\"~a.html\">Next</a></div>" next)
		       ""))))
    nav))

(defun footer ()
       "</body></html>")

(defun post (id title content)
  (format nil "~a~%~a~%~a~%~a~%" (header) (content title content) (navigation id) (footer)))

(defun get-posts (directory)
  (fad:list-directory directory))

(defun write-index (directory i)
  (format t "Writing index.html")
  (let ((out (open (format nil "~a/index.html" directory) :direction :output :if-exists :supersede)))
    (when out
      (format out (post i "foo" "bar"))
      (close out))))

(defun write-html (directory)
  (let ((posts (get-posts (format nil "~a/posts" directory)))
	(i 0))
    (dolist (post posts)
      (let ((out (open (format nil "~a/~d.html" directory i) :direction :output :if-exists :supersede)))
	(progn
	  (format t "Writing ~d.html~%" i)
	  (when (= i 0)
	    (write-index directory i))
	  (when out
	    (format out (post i "foo" "bar"))
	    (close out))
	  (setf i (+ i 1)))))))

(write-html "/home/krause/public_html/blog/")

