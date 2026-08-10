// Add another RegExp here to cover further page-name patterns.
const FIRST_VISIT_OVERLAY_PATTERNS: RegExp[] = [
	/^wit-DfeH.*\.html$/,
	/^wit-TFragment2.*\.html$/,
	/^wit-TParalipomenon.*\.html$/,
];

const OVERLAY_ID = 'first-visit-info-overlay';
const STORAGE_PREFIX = 'wpn-first-visit-overlay-seen:';

const filename = window.location.pathname.split('/').pop() ?? '';
const isMatchingPage = FIRST_VISIT_OVERLAY_PATTERNS.some((pattern) => pattern.test(filename));

if (isMatchingPage) {
	const storageKey = STORAGE_PREFIX + filename;
	const overlayElement = document.getElementById(OVERLAY_ID);
	if (overlayElement && !localStorage.getItem(storageKey)) {
		const overlay = new bootstrap.Modal(overlayElement);
		overlay.show();
		localStorage.setItem(storageKey, '1');
	}
}
