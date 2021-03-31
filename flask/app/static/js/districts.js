const elem = document.querySelector.bind(document);
let sel = undefined;

let district_ids = Array();

const district_select_div = elem('#district-select');
sel = district_select_div.querySelector.bind(district_select_div);
const district_select = {
  district: sel('select[name=district]'),
  districtid: undefined,
  button: sel('button')
};
district_select.button.addEventListener('click', changeDistrict);

const district_name_spans = document.querySelectorAll('.district-name');

const summary_div = elem('#district-summary');
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

const daily_div = elem('#district-daily');
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

function changeDistrict() {
  if (district_select.district.selectedIndex === -1) {
	return;
  }
  district_name_spans.forEach((span) => {
	span.textContent = district_select.district.value;
  });
  district_select.districtid = district_ids[district_select.district.selectedIndex];
  refreshAll();
}

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

  fetchget('/api/districts/summary', {
    districtid: district_select.districtid,
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

  fetchget('/api/districts/daily', {
    districtid: district_select.districtid,
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

function refreshAll() {
  refreshSummary();
  refreshDaily();
}

fetchget('/api/districts/list', {})
.then(response => {
  if (!response.ok)
	return undefined;
  return response.json();
}).then(data => {
  if (data === undefined) {
	window.alert('Unable to fetch list of districts!');
	return;
  }
  console.log(data);
  for (let i=0; i<data['district'].length; i++) {
	let opt = document.createElement('option');
	opt.textContent = data['district'][i];
	district_select.district.append(opt);
	district_ids.push(data['district_id'][i]);
  }

  let url = new URL(window.location.href);
  if (url.searchParams.has('districtid')) {
    district_select.district.selectedIndex = url.searchParams.get('districtid');
  } else {
    district_select.district.selectedIndex = 0;
  }
  changeDistrict();
});
