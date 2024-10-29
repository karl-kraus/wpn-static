interface TestDataObject {
	id: string;
	description: string;
};

export interface TestDataObjectIntertext extends TestDataObject {
	external_links?: Array<object>;
	register_links?: Array<object>;
	text_excerpts?: Array<object>;
	scans?: Array<object>;
	gnd_link?: Record<string,string>;
};

export interface TestDataObjectPerson extends TestDataObject {
	gnd_link?: Record<string,string>;
	register_link: Record<string, string>;
};

export interface TestDataObjectIntertextRegister extends TestDataObject {
	sortkey: string;
};

export interface TestDataObjectPersonRegister extends TestDataObject {
	gnd_link?: Record<string,string>;
	sortkey: string;
};

export interface TestDataObjectComment extends TestDataObject {
	event_date?: string,
	description_long: string;
	external_links?: Array<object>;
	timeline_links?: Array<object>;
	comment_links?: Array<object>;
	register_link?: Record<string, string>;
	sources?: string;
	
};



