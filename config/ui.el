;; Basic UI cleanup
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq visible-bell t)

;; UI commands
(defun move-frame-left-half ()
  "Move current frame to left half of screen."
  (interactive)
  (let* ((workarea (elt (display-monitor-attributes-list) 0))
         (geometry (alist-get 'workarea workarea))
	 (x (nth 0 geometry))
	 (y (nth 1 geometry))
         (width (- (/ (nth 2 geometry) 2) 12))  ; subtract 12 for gap
         (height (- (nth 3 geometry) 50)))
    (set-frame-position (selected-frame) x y)
    (set-frame-size (selected-frame) width height t)))

(defun move-frame-right-half ()
  "Move current frame to right half of screen."
  (interactive)
  (let* ((workarea (elt (display-monitor-attributes-list) 0))
         (geometry (alist-get 'workarea workarea))
         (x (+ (nth 0 geometry) (/ (nth 2 geometry) 2) 12))  ; add 12 for gap
         (y (nth 1 geometry))
         (width (- (/ (nth 2 geometry) 2) 12))  ; subtract 12 for gap
         (height (- (nth 3 geometry) 50)))
    (set-frame-position (selected-frame) x y)
    (set-frame-size (selected-frame) width height t)))

(provide 'ui)
