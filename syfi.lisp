(in-package #:syfi-init)

;;; ==================================================================
;;; Objective 2 scaffold
;;; ==================================================================
;;;
;;; A conduit that gathers only the tools that belong to one
;;; natural category.
;;;
;;; Later subpackages can follow the same shape:
;;;   syfi/namestring, syfi/mutate, syfi/logical,
;;;   syfi/cwd, syfi/wild, syfi/temp, …
;;; ==================================================================

;;;; ------------------------------------------------------------------
;;;; syfi/pathname
;;;;   Pure pathname *objects* – construction, predicates, components,
;;;;   normalisation, absolute/relative, logical/physical, wildcards.
;;;;
;;;; "Tools that operate on pathname objects themselves
;;;; (construction, predicates, component access, normalisation).
;;;; No filesystem I/O."

;; - pathname
;;   Pure pathname objects (no I/O).
;;   Construction, predicates, components, normalisation,
;;   absolute/relative, logical/physical, wildcards.

;;;; ------------------------------------------------------------------

(org.tfeb.conduit-packages:define-conduit-package #:syfi/pathname
  ;; Foundation
  (:extends #:uiop/pathname)

  ;; Useful extras from the modern stack (no known clashes with the
  ;; UIOP symbols we care about here)
  (:extends/excluding #:pathname-utils
                      ;; prefer UIOP
                      #:*wild-inferiors*
                      #:*wild-directory*
                      #:*wild-path*
                      #:*wild-file*
                      #:pathname-equal
                      #:enough-pathname
                      #:parse-unix-namestring
                      #:merge-pathnames*
                      #:unix-namestring
                      )

  ;; A few classic helpers that belong in this category
  (:extends/including #:cl-fad
                      #:pathname-as-directory
                      #:pathname-as-file
                      #:pathname-absolute-p
                      #:pathname-relative-p
                      #:pathname-root-p)

  ;; Selected ANSI operators that are pure pathname manipulation
  (:extends/including #:cl
                      #:pathname
                      #:pathnamep
                      #:make-pathname
                      #:parse-namestring
                      #:pathname-host
                      #:pathname-device
                      #:pathname-directory
                      #:pathname-name
                      #:pathname-type
                      #:pathname-version
                      #:merge-pathnames
                      #:wild-pathname-p
                      #:pathname-match-p
                      #:translate-pathname
                      #:logical-pathname
                      #:logical-pathname-translations
                      #:translate-logical-pathname
                      #:load-logical-pathname-translations))

;; ------------------------------------------------------------------
;; syfi/probe
;;   Existence / type queries – “does this path exist?”, “is it a
;;   file or a directory?”  Read-only filesystem contact.

;; "Read-only probes of the filesystem: existence, type, truename,
;; basic attributes.  No mutation."

;;  syfi/probe
;;  Existence and type queries (read-only).
;;  probe-file*, file-exists-p, directory-p, truename*, basic attributes.

;; ------------------------------------------------------------------

(org.tfeb.conduit-packages:define-conduit-package #:syfi/probe
  ;; UIOP probes
  (:extends/including #:uiop/filesystem
                      #:probe-file*
                      #:file-exists-p
                      #:directory-exists-p
                      #:truename*
                      #:safe-file-write-date)

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

;; ------------------------------------------------------------------
;; syfi/namestring
;; String ↔ pathname and pure string path manipulation.
;; Native/Unix/DOS namestrings, join, split, dirname/basename/extname.
;; ------------------------------------------------------------------
(org.tfeb.conduit-packages:define-conduit-package #:syfi/namestring)

;; ------------------------------------------------------------------
;; syfi/components
;; Fine-grained component access and reconstruction.
;; host/device/directory/name/type/version, plists, split-name-type.
;; ------------------------------------------------------------------
(org.tfeb.conduit-packages:define-conduit-package #:syfi/components)

;; ------------------------------------------------------------------
;; syfi/directory
;; Listing and walking.
;; directory*, directory-files, walk-directory, collect-sub*directories.
;; ------------------------------------------------------------------
(org.tfeb.conduit-packages:define-conduit-package #:syfi/directory)

;; ------------------------------------------------------------------
;; syfi/mutate
;; Creating, deleting, renaming, copying.
;; ensure-directories-exist, delete-directory-tree, copy-file*, rename\ldots
;; ------------------------------------------------------------------
(org.tfeb.conduit-packages:define-conduit-package #:syfi/mutate)

;; ------------------------------------------------------------------
;; syfi/logical
;; Logical pathnames.
;; logical-pathname, translations, translate-logical-pathname.
;; ------------------------------------------------------------------
(org.tfeb.conduit-packages:define-conduit-package #:syfi/logical)

;; ------------------------------------------------------------------
;; syfi/cwd
;; Current working directory and process context.
;; getcwd, with-current-directory, user-homedir-pathname.
;; ------------------------------------------------------------------
(org.tfeb.conduit-packages:define-conduit-package #:syfi/cwd)

;; ------------------------------------------------------------------
;; syfi/wild
;; Wildcard utilities.
;; *wild*, *wild-file*, *wild-directory*, wilden, pathname-match-p.
;; ------------------------------------------------------------------
(org.tfeb.conduit-packages:define-conduit-package #:syfi/wild)

;; ------------------------------------------------------------------
;; syfi/temp
;; Temporary files and staging.
;; temporary-file helpers, tmpize-pathname, tmpdir.
;; ------------------------------------------------------------------
(org.tfeb.conduit-packages:define-conduit-package #:syfi/temp)

;; ------------------------------------------------------------------
;; syfi/attributes
;; Rich file metadata.
;; size, extended timestamps, permissions\ldots
;; ------------------------------------------------------------------
(org.tfeb.conduit-packages:define-conduit-package #:syfi/attributes)

;; ------------------------------------------------------------------
;; syfi/search
;; High-level search and discovery.
;; file-finder / finder / finder*.
;; ------------------------------------------------------------------
(org.tfeb.conduit-packages:define-conduit-package #:syfi/search)

;; ------------------------------------------------------------------
;; syfi/config
;; User/application configuration and data locations.
;; nfiles, path-parse of $PATH, XDG-style resolution.
;; ------------------------------------------------------------------
(org.tfeb.conduit-packages:define-conduit-package #:syfi/config)

;; ------------------------------------------------------------------
;; syfi/special
;; Niche / legacy helpers.
;; illogical-pathnames, certain cl-ana utilities, etc.
;; ------------------------------------------------------------------
(org.tfeb.conduit-packages:define-conduit-package #:syfi/special)

;;; ==================================================================
;;; Objective 1 – the kitchen-sink entry point
;;; ==================================================================
;;;
;;; Still re-exports *everything*.  In addition it now also extends
;;; the two example subpackages so that
;;;
;;;   (use-package :syfi)
;;;
;;; continues to give the complete surface, while
;;;
;;;   (use-package :syfi/pathname)
;;;   (use-package :syfi/probe)
;;;
;;; give the smaller, categorical views.

;; "Re-export of virtually all Common Lisp pathname,
;; directory, filesystem and related utilities, and the kitchen-sink.
;; No renaming of symbols.
;;  UIOP is preferred on the few name collisions that are explicitly resolved below.

;; Also re-exports the categorical subpackages
;; syfi/purpose "

;;; ==================================================================

(org.tfeb.conduit-packages:define-conduit-package #:syfi
  ;; ----------------------------------------------------------------
  ;; 1. Core portable foundation – UIOP first
  ;; ----------------------------------------------------------------
  (:extends #:uiop/pathname)
  (:extends #:uiop/filesystem)

  ;; ----------------------------------------------------------------
  ;; 2. Classic libraries – exclude the colliding names we already
  ;;    took from UIOP
  ;; ----------------------------------------------------------------
  (:extends/excluding #:cl-fad
                      ;; prefer uiop
                      #:pathname-equal
                      #:pathname-directory-pathname
                      #:directory-pathname-p
                      #:directory-exists-p
                      #:file-exists-p
                      )

  ;; ----------------------------------------------------------------
  ;; 3. Shinmera stack
  ;; ----------------------------------------------------------------
  (:extends/excluding #:org.shirakumo.filesystem-utils
                      #:with-current-directory
                      #:directory*
                      #:truename*
                      #:file-exists-p
                      #:copy-file
                      #:directory-p
                      )

  (:extends/excluding #:pathname-utils
                      #:*wild-directory*
                      #:*wild-inferiors*
                      #:*wild-path*
                      #:*wild-file*
                      #:pathname-equal
                      #:merge-pathnames*
                      #:parse-unix-namestring
                      #:file-p
                      #:enough-pathname
                      #:unix-namestring
                      #:parse-native-namestring
                      #:native-namestring)

  ;; ----------------------------------------------------------------
  ;; 4. Higher-level / specialised libraries
  ;; ----------------------------------------------------------------
  (:extends/excluding #:file-finder
                      #:with-current-directory
                      #:list-directory
                      #:current-directory
                      #:parent)

  (:extends/excluding #:path-string
                      #:absolute-p
                      #:basename)

  (:extends/excluding #:illogical-pathnames)

  (:extends/excluding #:temporary-file
                      #:invalid-temporary-pathname-template
                      #:cannot-create-temporary-file
                      #:open-temporary
                      #:with-output-to-temporary-file
                      #:*default-template*
                      #:with-open-temporary-file)

  (:extends/excluding #:tmpdir)

  (:extends/excluding #:org.shirakumo.file-attributes)

  (:extends/excluding #:org.shirakumo.file-notify)

  (:extends/excluding #:com.gigamonkeys.pathnames
                      #:directory-pathname-p
                      #:file-pathname-p
                      #:file-exists-p
                      #:pathname-as-file
                      #:list-directory
                      #:walk-directory
                      #:pathname-as-directory
                      #:file-p
                      #:directory-p)

  (:extends/excluding #:trivial-file-size)

  (:extends/excluding #:copy-directory)

  (:extends/excluding #:nfiles
                      #:directory-pathname-p
                      #:parent
                      #:basename
                      #:file
                      #:resolve
                      #:join)

  (:extends/excluding #:path-parse
                      #:path)

  (:extends/excluding #:mnas-path)

  (:extends/excluding #:cl-ana.pathname-utils
                      #:directory-pathname-p
                      #:pathname-absolute-p
                      #:pathname-relative-p
                      #:basename
                      #:dirname)

  (:extends/excluding #:cl-ana.file-utils)

  ;; ----------------------------------------------------------------
  ;; 5. Selected ANSI CL pathname operators
  ;; ----------------------------------------------------------------
  (:extends/including #:cl
                      #:pathname
                      #:pathnamep
                      #:make-pathname
                      #:parse-namestring
                      #:namestring
                      #:file-namestring
                      #:directory-namestring
                      #:host-namestring
                      #:enough-namestring
                      #:pathname-host
                      #:pathname-device
                      #:pathname-directory
                      #:pathname-name
                      #:pathname-type
                      #:pathname-version
                      #:merge-pathnames
                      #:wild-pathname-p
                      #:pathname-match-p
                      #:translate-pathname
                      #:logical-pathname
                      #:logical-pathname-translations
                      #:translate-logical-pathname
                      #:load-logical-pathname-translations
                      #:probe-file
                      #:truename
                      #:directory
                      #:ensure-directories-exist
                      #:file-write-date
                      #:file-author
                      #:rename-file
                      #:delete-file
                      #:*default-pathname-defaults*
                      #:user-homedir-pathname))
