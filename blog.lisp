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

(let ((post (post 1 "Help" "Lorem ipsum blah blah blag")))
  (format t post))
