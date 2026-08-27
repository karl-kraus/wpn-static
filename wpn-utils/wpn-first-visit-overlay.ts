// Add another RegExp here to cover further page-name patterns.
const FIRST_VISIT_OVERLAY_PATTERNS: RegExp[] = [
	/^wit-DfeH.*\.html$/,
	/^wit-TFragment2.*\.html$/,
	/^wit-TParalipomenon.*\.html$/,
];

const OVERLAY_ID = 'first-visit-info-overlay';
const STORAGE_PREFIX = 'wpn-first-visit-overlay-seen:';

const filename = window.location.pathname.split('/').pop() ?? '';
const matchedPattern = FIRST_VISIT_OVERLAY_PATTERNS.find((pattern) => pattern.test(filename));

if (matchedPattern) {
	const storageKey = STORAGE_PREFIX + matchedPattern.source;
	const overlayElement = document.getElementById(OVERLAY_ID);
	if (overlayElement && !localStorage.getItem(storageKey)) {
		const overlay = new bootstrap.Modal(overlayElement);
		overlay.show();
		localStorage.setItem(storageKey, '1');
	}
}
