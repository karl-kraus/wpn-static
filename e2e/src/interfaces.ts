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



