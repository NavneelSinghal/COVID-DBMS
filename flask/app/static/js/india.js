const elem = document.querySelector.bind(document);
let sel = undefined;

const summary_div = elem('#india-summary');
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
refreshSummary();

const daily_div = elem('#india-daily');
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
refreshDaily();

const vaccinations_div = elem('#india-vaccinations');
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
refreshVaccinations();

const states_div = elem('#india-states');
sel = states_div.querySelector.bind(states_div);
const states = {
  refresh : sel('input[name=refresh-button]'),
  parameter: sel('select[name=parameter]'),
  order: sel('select[name=order]'),
  tableheader: sel('thead').firstElementChild,
  tablebody: sel('tbody')
};

states.refresh.addEventListener('click', refreshStates);
refreshStates();

const analysis_div = elem('#india-analysis');
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
  query: sel('select[name=query]'),
  tableheader: sel('thead').firstElementChild,
  tablebody: sel('tbody')
};

analysis.refresh.addEventListener('click', refreshAnalysis);
refreshAnalysis();

function refreshSummary() {
  let selectedCols = Array();
  summary.columns.forEach((checkbox) => {
	if (checkbox.checked) {
	  selectedCols.push(checkbox.value);
	}
  });
  if (selectedCols.length === 0) {
	window.alert('Please select atleast one column');
	return;
  }

  fetchget('/api/india/summary', {
	from: summary.from.value,
	to: summary.to.value
  }).then(response => response.json()
  ).then(data => {
	console.log(data);
	//Clear existing table header and add new
	
	let header = document.createElement('tr');
	selectedCols.forEach((column) => {
	  let th = document.createElement('th');
	  th.textContent = column;
	  header.append(th);
	});
	summary.tableheader.replaceChildren(header);

	let values = document.createElement('tr');
	selectedCols.forEach((column) => {
	  let td = document.createElement('td');
	  td.textContent = data[column][0];
	  values.append(td);
	});
	summary.tablebody.replaceChildren(values);
  });
}

function refreshDaily() {
  let type = daily.type.value;
  let param = daily.parameter.value;
  let ndays = daily.ndays.value;

  fetchget('/api/india/daily', {
	type: type,
	parameter: param,
	ndays: ndays
  })
  .then(response => response.json())
  .then(data => {
	/* Refresh chart */
	console.log(data);
	daily.chart.data.datasets[0].label = param;
	daily.chart.data.labels = data['Date'];
	daily.chart.data.datasets[0].data = data[param];
	daily.chart.update();
  });
}

function refreshVaccinations() {
  let selectedCols = Array();
  vaccinations.columns.forEach((checkbox) => {
	if (checkbox.checked) {
	  selectedCols.push(checkbox.value);
	}
  });
  if (selectedCols.length === 0) {
	window.alert('Please select atleast one column');
	return;
  }

  fetchget('/api/india/vaccine', {
	from: vaccinations.from.value,
	to: vaccinations.to.value
  }).then(
	response => response.json()
  ).then(
	data => {
	  //Clear existing table header and add new
	  console.log(data);
	  let header = document.createElement('tr');
	  selectedCols.forEach((column) => {
		let th = document.createElement('th');
		th.textContent = column;
		header.append(th);
	  });
	  vaccinations.tableheader.replaceChildren(header);

	  let values = document.createElement('tr');
	  selectedCols.forEach((column) => {
		let td = document.createElement('td');
		td.textContent = data[column][0];
		values.append(td);
	  });
	  vaccinations.tablebody.replaceChildren(values);
	}
  );
}

function refreshStates() {
  let param = states.parameter.value;
  let order = states.order.value;

  /* We will make api call here, for now assume dummy values */

  fetchget('/api/india/liststates', {
	sortedby: param,
	sortedin: order
  }).then(
	response => response.json()
  ).then(
	data => {
	  console.log(data);
	  let rows = Array();
	  for (let i=0; i<data['Name'].length; i++) {
		let row = document.createElement('tr');
		for (let j=0; j<states.tableheader.children.length; j++) {
		  let column = states.tableheader.children[j].textContent;
		  let td = document.createElement('td');
		  td.textContent = data[column][i];
		  row.append(td);
		}
		rows.push(row);
	  }
	  states.tablebody.replaceChildren(...rows);
	}
  );
}

function refreshAnalysis() {
  fetchget('/api/india/analysis', {
	from: analysis.from.value,
	to: analysis.to.value,
	type: analysis.type.value,
	parameter: analysis.parameter.value,
	query: analysis.query.value
  }).then(
	response => response.json()
  ).then(
	data => {
	  console.log(data);

	  let rows = Array();
	  for (let i=0; i<data['Date'].length; i++) {
		let tr = document.createElement('tr');
		let td1 = document.createElement('td');
		let td2 = document.createElement('td');
		td1.textContent = data['Date'][i];
		td2.textContent = data[analysis.parameter.value][i];
		tr.replaceChildren(td1, td2);
		rows.push(tr);
	  }
	  analysis.tablebody.replaceChildren(...rows);
	}
  );
}
