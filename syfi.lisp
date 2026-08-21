;;;; Objective 1 – pure kitchen-sink conduit package.
;;;; Objective 2 (partial) – two example categorical subpackages
;;;;              that serve as a scaffold for later expansion.
;;;;
;;;; Prefer UIOP on selected name collisions

(in-package #:file-sysys-system)

;;; ==================================================================
;;; Objective 2 scaffold – two small, intention-revealing subpackages
;;; ==================================================================
;;;
;;; These are deliberately incomplete.  They demonstrate the pattern:
;;;
;;;   1. A conduit that gathers only the tools that belong to one
;;;      natural category.
;;;   2. The top-level file-sysys still re-exports everything
;;;      (including the subpackages) so the kitchen-sink entry point
;;;      remains complete.
;;;
;;; Later subpackages can follow the same shape:
;;;   file-sysys/namestring, file-sysys/mutate, file-sysys/logical,
;;;   file-sysys/cwd, file-sysys/wild, file-sysys/temp, …
;;; ==================================================================

;;;; ------------------------------------------------------------------
;;;; file-sysys/pathname
;;;;   Pure pathname *objects* – construction, predicates, components,
;;;;   normalisation, absolute/relative, logical/physical, wildcards.
;;;; ------------------------------------------------------------------

(org.tfeb.conduit-packages/define-package:define-conduit-package #:file-sysys/pathname
  "Tools that operate on pathname objects themselves
(construction, predicates, component access, normalisation).
No filesystem I/O."

  ;; Foundation
  (:extends #:uiop/pathname)

  ;; Useful extras from the modern stack (no known clashes with the
  ;; UIOP symbols we care about here)
  (:extends/excluding #:pathname-utils
   #:pathname-equal)          ; already have the UIOP version

  ;; A few classic helpers that belong in this category
  (:extends/including #:cl-fad
   #:pathname-as-directory
   #:pathname-as-file
   #:directory-pathname-p
   #:pathname-absolute-p
   #:pathname-relative-p
   #:pathname-root-p)

  ;; Selected ANSI operators that are pure pathname manipulation
  (:extends/including #:cl
   #:pathname #:pathnamep
   #:make-pathname #:parse-namestring
   #:pathname-host #:pathname-device #:pathname-directory
   #:pathname-name #:pathname-type #:pathname-version
   #:merge-pathnames #:wild-pathname-p #:pathname-match-p
   #:translate-pathname
   #:logical-pathname #:logical-pathname-p
   #:logical-pathname-translations #:translate-logical-pathname
   #:load-logical-pathname-translations))

;;;; ------------------------------------------------------------------
;;;; file-sysys/probe
;;;;   Existence / type queries – “does this path exist?”, “is it a
;;;;   file or a directory?”  Read-only filesystem contact.
;;;; ------------------------------------------------------------------

(org.tfeb.conduit-packages/define-package:define-conduit-package #:file-sysys/probe
  "Read-only probes of the filesystem: existence, type, truename,
basic attributes.  No mutation."

  ;; UIOP probes
  (:extends/including #:uiop/filesystem
   #:probe-file*
   #:file-exists-p
   #:directory-exists-p
   #:truename*
   #:safe-file-write-date)

  ;; CL-FAD probes
  (:extends/including #:cl-fad
   #:directory-exists-p
   #:file-exists-p)

  ;; Pathname-utils / filesystem-utils predicates that answer
  ;; “what kind of thing is this path?”
  (:extends/including #:pathname-utils
   #:directory-p
   #:file-p
   #:absolute-p
   #:relative-p
   #:root-p
   #:logical-p
   #:physical-p)

  ;; ANSI
  (:extends/including #:cl
   #:probe-file
   #:truename
   #:file-write-date
   #:file-author))

;;; ==================================================================
;;; Objective 1 – the kitchen-sink entry point
;;; ==================================================================
;;;
;;; Still re-exports *everything*.  In addition it now also extends
;;; the two example subpackages so that
;;;
;;;   (use-package :file-sysys)
;;;
;;; continues to give the complete surface, while
;;;
;;;   (use-package :file-sysys/pathname)
;;;   (use-package :file-sysys/probe)
;;;
;;; give the smaller, categorical views.
;;; ==================================================================

(org.tfeb.conduit-packages/define-package:define-conduit-package #:file-sysys
  "Kitchen-sink re-export of virtually all Common Lisp pathname,
directory, filesystem and related utilities.  No renaming of symbols.
UIOP is preferred on the few name collisions that are explicitly
resolved below.

Also re-exports the categorical subpackages
file-sysys/pathname and file-sysys/probe.

(Excludes osicat by design.)"

  ;; ----------------------------------------------------------------
  ;; Categorical subpackages (Objective 2 scaffold)
  ;; ----------------------------------------------------------------
  (:extends #:file-sysys/pathname)
  (:extends #:file-sysys/probe)

  ;; ----------------------------------------------------------------
  ;; 1. Core portable foundation – UIOP first so its symbols win
  ;; ----------------------------------------------------------------
  (:extends #:uiop/pathname)
  (:extends #:uiop/filesystem)

  ;; ----------------------------------------------------------------
  ;; 2. Classic libraries – exclude the colliding names we already
  ;;    took from UIOP
  ;; ----------------------------------------------------------------
  (:extends/excluding #:cl-fad
   #:pathname-equal)          ; prefer uiop:pathname-equal

  (:extends #:com.gigamonkeys.pathnames)

  ;; ----------------------------------------------------------------
  ;; 3. Modern Shinmera stack
  ;; ----------------------------------------------------------------
  (:extends/excluding #:pathname-utils
   #:pathname-equal)          ; prefer uiop

  (:extends #:filesystem-utils)

  ;; ----------------------------------------------------------------
  ;; 4. Higher-level / specialised libraries
  ;; ----------------------------------------------------------------
  (:extends #:file-finder)
  (:extends #:ppath)
  (:extends #:path-string)
  (:extends #:illogical-pathnames)
  (:extends #:temporary-file)
  (:extends #:tmpdir)
  (:extends #:file-attributes)
  (:extends #:trivial-file-size)
  (:extends #:copy-directory)
  (:extends #:nfiles)
  (:extends #:path-parse)
  (:extends #:mnas-path)
  (:extends #:pathnames)
  (:extends #:cl-ana.pathname-utils)
  (:extends #:cl-ana.file-utils)

  ;; ----------------------------------------------------------------
  ;; 5. Selected ANSI CL pathname operators
  ;; ----------------------------------------------------------------
  (:extends/including #:cl
   #:pathname #:pathnamep
   #:make-pathname #:parse-namestring #:namestring
   #:file-namestring #:directory-namestring #:host-namestring #:enough-namestring
   #:pathname-host #:pathname-device #:pathname-directory
   #:pathname-name #:pathname-type #:pathname-version
   #:merge-pathnames #:wild-pathname-p #:pathname-match-p
   #:translate-pathname
   #:logical-pathname #:logical-pathname-p
   #:logical-pathname-translations #:translate-logical-pathname
   #:load-logical-pathname-translations
   #:probe-file #:truename #:directory
   #:ensure-directories-exist
   #:file-write-date #:file-author
   #:rename-file #:delete-file
   #:*default-pathname-defaults*
   #:user-homedir-pathname))
