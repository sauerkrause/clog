(require 'cl-fad)
(require 'cl-markdown)
(require 'cl-ppcre)

(let ((posts nil))
  (defun header (title)
    (format nil "<html>
         <title>~a</title>
  	 <body>" title))

  (defun content (content)
    (format nil "<div class=\"content\">~a</div>" content))

  (defun nextp (id)
    (<= (+ id 1) (length posts)))

  (defun prevp (id)
    (> (- id 1) 0))

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
    (format nil "~a~%~a~%~a~%~a~%" (header title) (content content) (navigation id) (footer)))

  (defun get-posts (directory)
    (fad:list-directory directory))

  (defun get-post-title (path)
    (with-open-file (input path :direction :input)
		    (ppcre:regex-replace "^\w*\#*\w*" (read-line input nil) "")))

  (defun slurp-stream (stream)
    (let ((seq (make-string (file-length stream))))
      (read-sequence seq stream)
      seq))

  (defun get-post-body (path)
    (with-open-file (input path :direction :input)
		    (let ((contents (slurp-stream input)))
		      (multiple-value-bind (doc str)
			  (markdown:markdown contents :stream nil :format :html)
			str))))

  (defun write-index (directory i post)
    (format t "Writing index.html")
    (with-open-file (out (format nil "~a/index.html" directory) :direction :output :if-exists :supersede)
		    (format out (post i (get-post-title post) (get-post-body post)))))

  (defun write-html (directory)
    (setf posts (get-posts (format nil "~a/posts" directory)))
    (let ((i (length posts)))
      (dolist (post posts)
	(with-open-file (out (format nil "~a/~d.html" directory i) :direction :output :if-exists :supersede)
			(progn
			  (format t "Writing ~d.html~%" i)
			  (when (= i (length posts))
			    (write-index directory i post))
			  (format out (post i (get-post-title post) (get-post-body post)))
			  (setf i (- i 1))))))))

(write-html "/home/krause/public_html/blog/")
