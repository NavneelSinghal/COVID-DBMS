const elem = document.querySelector.bind(document);
let sel = undefined;

let state_ids = Array();

const state_select_div = elem('#state-select');
sel = state_select_div.querySelector.bind(state_select_div);
const state_select = {
  state: sel('select[name=state]'),
  stateid: undefined,
  button: sel('button')
};
state_select.button.addEventListener('click', changeState);

const state_name_spans = document.querySelectorAll('.state-name');

const summary_div = elem('#state-summary');
sel = summary_div.querySelector.bind(summary_div);
const summary = {
  refresh : sel('input[name=refresh-button]'),
  from : sel('input[name=date-from]'),
  to : sel('input[name=date-to]'),
  columns : sel('.column-picker').querySelectorAll('input[type="checkbox"]'),
  tableheader: sel('thead'),
  tablebody: sel('tbody')
};
summary.refresh.addEventListener('click', refreshSummary);

const daily_div = elem('#state-daily');
sel = daily_div.querySelector.bind(daily_div);
const daily = {
  refresh : sel('input[name=refresh-button]'),
  type: sel('select[name=type]'),
  parameter: sel('select[name=parameter]'),
  ndays : sel('input[name=ndays]'),
  canvas: sel('canvas'),
  chart: undefined
};

daily.chart = new Chart(daily.canvas,
  {
	type: 'bar',
	data: {
	  labels: [],
	  datasets: [{
		label: '',
		data: [],
		backgroundColor: 'rgba(0, 0, 255, 1)',
		borderColor: 'black',
		borderWidth: 1
	  }]
	},
	options: {
	  responsive: false
	}
  }
);
daily.refresh.addEventListener('click', refreshDaily);

const vaccinations_div = elem('#state-vaccinations');
sel = vaccinations_div.querySelector.bind(vaccinations_div);
const vaccinations = {
  refresh : sel('input[name=refresh-button]'),
  from : sel('input[name=date-from]'),
  to : sel('input[name=date-to]'),
  columns : sel('.column-picker').querySelectorAll('input[type="checkbox"]'),
  tableheader: sel('thead'),
  tablebody: sel('tbody')
};
vaccinations.refresh.addEventListener('click', refreshVaccinations);

const districts_div = elem('#state-districts');
sel = districts_div.querySelector.bind(districts_div);
const districts = {
  refresh : sel('input[name=refresh-button]'),
  parameter: sel('select[name=parameter]'),
  order: sel('select[name=order]'),
  tableheader: sel('thead').firstElementChild,
  tablebody: sel('tbody')
};
districts.refresh.addEventListener('click', refreshDistricts);

const analysis_div = elem('#state-analysis');
sel = analysis_div.querySelector.bind(analysis_div);
const analysis = {
  refresh : sel('input[name=refresh-button]'),
  granularity: sel('select[name="granularity"]'),
  from: sel('input[name=date-from]'),
  to: sel('input[name=date-to]'),
  type: sel('select[name=type]'),
  parameter: sel('select[name=parameter]'),
  optgroups: {
	both: sel('optgroup[name=both]'),
	daily: sel('optgroup[name=daily]'),
	cumulative: sel('optgroup[name=cumulative]')
  },
  query: sel('select[name=query]')
};
analysis.refresh.addEventListener('click', refreshAnalysis);
analysis.type.addEventListener('change', validateAnalysisParameter);

function changeState() {
  if (state_select.state.selectedIndex === -1) {
	return;
  }
  state_name_spans.forEach((span) => {
	span.textContent = state_select.state.value;
  });
  state_select.stateid = state_ids[state_select.state.selectedIndex];

  refreshSummary();
  refreshDaily();
  refreshVaccinations();
  refreshDistricts();
  refreshAnalysis();
}

function refreshSummary() {}
function refreshDaily() {}
function refreshVaccinations() {}
function refreshDistricts() {}
function refreshAnalysis() {}
function validateAnalysisParameter(event) {
  let val = event.target.value;
  if (val === 'Cumulative') {
	analysis.optgroups.daily.disabled = true;
	analysis.optgroups.cumulative.disabled = false;
  } else {
	analysis.optgroups.daily.disabled = false;
	analysis.optgroups.cumulative.disabled = true;
  }
}

fetchget('/api/states/list', {})
.then(response => {
  if (!response.ok)
	return undefined;
  return response.json();
}).then(data => {
  if (data === undefined) {
	window.alert('Unable to fetch list of states!');
	return;
  }
  data.states.forEach((state) => {
	let opt = document.createElement('option');
	opt.textContent = state.name;
	state_select.state.append(opt);
	state_ids.push(state.id);
  });
});
