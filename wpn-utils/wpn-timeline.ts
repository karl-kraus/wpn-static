/// <reference path="../node_modules/anychart/dist/index.d.ts"/>

import timeLineData from "./timeline_data/timeline_data.json";

interface RangeDataItem {
	id: string;
	name: string;
	start: string;
	end: string;
}

interface MomentDataItem {
	id: string;
	x: string;
	y: string;
}

class WPNTimeLine extends HTMLElement {
	private chart: anychart.charts.Timeline | null = null;
	private rangeDataSet = anychart.data.set(
		timeLineData.rangeData.filter((item) => item.categories.length > 0),
	);
	private momentDataSet = anychart.data.set(
		timeLineData.momentData.filter((item) => item.categories.length > 0),
	);
	static get observedAttributes() {
		return ['data-selected-categories', 'data-highlighted-category'];
	}

	connectedCallback() {
		anychart.format.outputLocale("de-at");
		this.chart = anychart.timeline();

		// create a range series
		const rangeSeries = this.chart.range(this.rangeDataSet);
		rangeSeries.id("rangeSeries");

		// create a moment series
		const momentSeries = this.chart.moment(this.momentDataSet);
		momentSeries.id("momentSeries");

		// no data label
		const noDataLabel = this.chart.noData().label();
		noDataLabel.enabled(true);
		noDataLabel.text("Bitte wählen Sie eine Kategorie aus");

		// style range series
		rangeSeries.normal().fill("#F3F3F3");
		rangeSeries.normal().stroke("#D8D8D8", 1, 0);
		rangeSeries
			.labels()
			.useHtml(true)
			.fontColor("#999999")
			.format((item: any) => {
				const dataItem = item as RangeDataItem;
				const start = dataItem.start ? String(new Date(dataItem.start).getFullYear()) : "";
				const end = dataItem.end ? String(new Date(dataItem.end).getFullYear()) : "";
				//const name = dataItem.getStat("y")
				return `<span><span>${start} –  ${end}
					</span><br><span style="color:#404040">
					${String(item.getStat('name'))}
					</span></span>`;
			});
		rangeSeries
			.selected()
			.labels()
			.useHtml(true)
			.fontColor("#999999")
			.format((item: any) => {
				const dataItem = item as RangeDataItem;
				const start = dataItem.start ? String(new Date(dataItem.start).getFullYear()) : "";
				const end = dataItem.end ? String(new Date(dataItem.end).getFullYear()) : "";
				return `<span style="color:#404040">${start} – ${end}
					</span><br><span style="color:#A21A17">
					${String(item.getStat('name'))}
					</span>`;
			});
		rangeSeries.labels().textOverflow("...");
		rangeSeries.labels().padding().left(10);
		rangeSeries.selected().stroke("#A21A17", 1, "0");
		rangeSeries.hovered().stroke("#A21A17", 1, "0");
		rangeSeries.height(50);
		rangeSeries.selected().fill("#FAF3F3");
		rangeSeries.tooltip().useHtml(true);
		rangeSeries.tooltip().format((item: any) => {
			const dataItem = item as RangeDataItem;
			const start = dataItem.start
				? anychart.format.dateTime(new Date(dataItem.start), "dd. MMM ")
				: "";
			const end = dataItem.end ? anychart.format.dateTime(new Date(dataItem.end), "dd. MMM ") : "";
			return `<span style='font-weight:600;font-size:10pt'>
					${String(item.getStat("name"))}
					</span><br><br>Von 
					${start} 
					${String(new Date(dataItem.start).getFullYear())} – 
					${end} 
					${String(new Date(dataItem.end).getFullYear().toString())}
					<span/>`;
		});
		rangeSeries.tooltip().title().enabled(false);
		rangeSeries.tooltip().separator().enabled(false);

		//style moment series
		momentSeries.labels().padding().left(10);
		momentSeries.labels().background("#F3F3F3");
		momentSeries.selected().labels().background("#FAF3F3");
		momentSeries.labels().background().corners(0);
		momentSeries.labels().background().stroke("#D8D8D8", 1, 0);
		momentSeries.normal().stroke("#D8D8D8", 1, "0");
		// customize the moment series marker
		momentSeries.markers().type("circle");
		momentSeries.normal().markers().stroke("#D8D8D8");
		momentSeries.labels().offsetX(-0.5);
		momentSeries.hovered().markers().size(4);
		momentSeries.hovered().stroke("#A21A17", 1, "0");
		momentSeries.hovered().markers().fill("#A21A17");
		momentSeries.hovered().markers().stroke("#A21A17");
		momentSeries.hovered().labels().background().stroke("#A21A17", 1, "0");
		momentSeries.selected().markers().size(4);
		momentSeries.selected().stroke("#A21A17", 1, "0");
		momentSeries.selected().markers().fill("#A21A17");
		momentSeries.selected().markers().stroke("#A21A17");
		momentSeries.selected().labels().background().stroke("#A21A17", 1, "0");

		momentSeries.selected().labels().enabled(true);
		momentSeries
			.labels()
			.useHtml(true)
			.fontColor("#999999")
			.format((item: any) => {
				const dataItem = item as MomentDataItem;
				const x = dataItem.x ? anychart.format.dateTime(new Date(dataItem.x), "dd. MMM ") : "";
				//const y = this.getStat("y")
				return `<span><span>
					${x}
					${String(new Date(dataItem.x).getFullYear())}
					</span><br><span style="color:#404040">
					${String(dataItem.getStat('y'))}
				 </span>`;
			});
		momentSeries
			.selected()
			.labels()
			.useHtml(true)
			.fontColor("##999999")
			.format((item: any) => {
				const dataItem = item as MomentDataItem;
				const x = dataItem.x ? anychart.format.dateTime(new Date(dataItem.x), "dd. MMM ") : "";
				return `<span><span style="color:#404040">
					${x}
					${String(new Date(dataItem.x).getFullYear())}
					'</span><br><span style="color:#A21A17">
					${String(dataItem.getStat('y'))}
					</span>`;
			});
		momentSeries.labels().textOverflow("...");
		momentSeries.tooltip().useHtml(true);
		momentSeries.tooltip().format((item: any) => {
			const dataItem = item as MomentDataItem;
			const x = dataItem.x ? anychart.format.dateTime(new Date(dataItem.x), "dd. MMM ") : "";
			return `<span style='font-weight:600;font-size:10pt'>
			${String(dataItem.getStat('y'))}
					</span><br><br><span>
					${x}
					${new Date(dataItem.x).getFullYear().toString()}
					</span>`;
		});
		momentSeries.tooltip().title().enabled(false);
		momentSeries.tooltip().separator().enabled(false);

		// style axis
		this.chart.axis().fill("#a21a17");
		this.chart.axis().stroke("#a21a17");
		this.chart.axis().ticks().stroke("#FFFFFF", 1);

		// enable scroller
		this.chart.scroller().enabled(true);

		// style scroller
		this.chart.scroller().minHeight(30);
		this.chart.scroller().padding(0, 0, -10, 0);
		this.chart.scroller().fill("#C41F1B");
		this.chart.scroller().selectedFill("#a21a17");

		//define intial zoom
		this.chart.zoomTo(Date.UTC(1933, 0, 30), Date.UTC(1933, 6, 31));

		//select event
		this.chart.listen("pointsSelect", (e: any) => {
			const point = e.point as anychart.core.Point;
		 	window.location.hash = e.point.getStat("id");         
		 	e.point.set('index', 10000);
 		})

		this.chart.container(this.id);
		this.chart.draw();
	}
	attributeChangedCallback(name, oldValue, newValue) {
		if (name === 'data-selected-categories') {
			const selectedCategories: unknown = JSON.parse(newValue as string);
			if (Array.isArray(selectedCategories)) {
				if (selectedCategories.length > 0) {
					this.chart?.axis().enabled(true);
					const filteredRangeDataSet = this.rangeDataSet.mapAs().filter("categories", function (cat: Array<string>) {
						return cat.some(r => selectedCategories.includes(r));
					});
					const filteredMomentDataSet = this.momentDataSet.mapAs().filter("categories", function (cat: Array<string>) {
						return cat.some(r => selectedCategories.includes(r));
					});
					this.chart?.getSeries("rangeSeries").data(filteredRangeDataSet);
					this.chart?.getSeries("momentSeries").data(filteredMomentDataSet);
					this.chart?.zoomTo(Date.UTC(1933, 0, 30), Date.UTC(1933, 6, 31));
				}
				else {
					this.chart?.axis().enabled(false);
					this.chart?.getSeries("rangeSeries").data([]);
					this.chart?.getSeries("momentSeries").data([]);
				}
			}
		}
		if (name === 'data-highlighted-category') {
			const highlightedCategory = String(newValue);
			const filteredRangeDataSet = this.rangeDataSet.mapAs().filter("categories", function (cat: Array<string>) {
				return cat.some(r => highlightedCategory === r);
			});
			const filteredMomentDataSet = this.momentDataSet.mapAs().filter("categories", function (cat: Array<string>) {
				return cat.some(r => highlightedCategory === r);
			});
			const iteratorMoments = filteredMomentDataSet.getIterator();
			const iteratorRanges = filteredRangeDataSet.getIterator();

			const momentSeries = this.chart?.getSeries("momentSeries");
			const rangeSeries = this.chart?.getSeries("rangeSeries");

			const momentPointsIndexes = [];
			const rangePointsIndexes = [];
			
			if (momentSeries && rangeSeries) {
				while (iteratorMoments.advance()) {
					const ptIndex = momentSeries.getPoint(momentSeries.data().find("id", iteratorMoments.get("id"))).getIndex();
					momentPointsIndexes.push(ptIndex);
				}
				while (iteratorRanges.advance()) {
					const ptIndex = rangeSeries.getPoint(rangeSeries.data().find("id", iteratorRanges.get("id"))).getIndex();
					rangePointsIndexes.push(ptIndex);
				}
				if (highlightedCategory) {
					momentSeries.hover(momentPointsIndexes);
					rangeSeries.hover(rangePointsIndexes);
				} else {
					momentSeries.unhover();
					rangeSeries.unhover();
				}
			}
		}
	}

	disconntedCallback() {
		if (this.chart) {
			this.chart.dispose();
			this.chart = null;
		}
	}
}

customElements.define("wpn-time-line", WPNTimeLine);
