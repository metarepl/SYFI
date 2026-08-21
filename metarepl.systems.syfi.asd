;;;;
;;;; Kitchen-sink re-export of Common Lisp pathname, directory and
;;;; filesystem tools.  Pure discovery entry point; no renaming.
;;;; Prefers UIOP on known name collisions.
;;;;
;;;; Also provides a partial Objective-2 scaffold of categorical
;;;; subpackages (syfi/pathname, syfi/probe).

(defsystem "metarepl.systems.syfi"
  :description "Comprehensive categorical re-export of Common Lisp pathname, directory and filesystem tools ."
  :author "metarepl (https://github.com/metarepl)"
  :version "0.0.1"
  :license "MIT"
  :depends-on (:org.tfeb.conduit-packages
               :uiop
               :cl-fad
               :pathname-utils
               :filesystem-utils
               :file-notify
               :file-finder
               :path-string
               :illogical-pathnames
               :com.gigamonkeys.pathnames
               :temporary-file
               :tmpdir
               :file-attributes
               :trivial-file-size
               :copy-directory
               :nfiles
               :path-parse
               :mnas-path
               :cl-ana.pathname-utils
               :cl-ana.file-utils)
  :serial t
  :components ((:static-file "README.org")
               (:file "package")
               (:file "syfi")))
