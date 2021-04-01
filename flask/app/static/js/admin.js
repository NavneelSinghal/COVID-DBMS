const elem = document.querySelector.bind(document);
let sel = undefined;

const tabs = elem('#tabs');
tabs.addEventListener('click', switchTabs);

const update_div = elem('#update-tab');
sel = update_div.querySelector.bind(update_div);
const updatetab = {
  div: update_div,
  casestable: sel('table[id=update-cases]').firstElementChild,
  vaccinationstable: sel('table[id=update-vaccinations]').firstElementChild,
  refreshtable: sel('table[id=refresh-all]').firstElementChild
};

sel = updatetab.casestable.querySelector.bind(updatetab.casestable);
const cases = {
  state: sel('select[name=state]'),
  district: sel('select[name=district]'),
  date: sel('input[name=date]'),
  rows: [],
  button: sel('button')
};
for (let i=0; i<updatetab.casestable.children.length; i++) {
  let row = updatetab.casestable.children.item(i);
  if (row.hasAttribute('name')) {
    cases.rows.push({
      name: row.getAttribute('name'),
      statetd: row.children.item(1),
      districttd: row.children.item(2),
      input: row.children.item(3).firstElementChild
    });
  }
}
cases.state.addEventListener('change', () => updateState(
  cases.state, cases.district, cases.district
));
cases.district.addEventListener('change', () => updateDistrict(
  cases.district, cases.date
));
cases.date.addEventListener('change', updateCasesDate);
cases.button.addEventListener('click', postCases);
cases.district.disabled = true;
cases.date.disabled = true;
cases.button.disabled = true;

sel = updatetab.vaccinationstable.querySelector.bind(updatetab.vaccinationstable);
const vaccinations = {
  state: sel('select[name=state]'),
  date: sel('input[name=date]'),
  rows: [],
  button: sel('button')
};
for (let i=0; i<updatetab.vaccinationstable.children.length; i++) {
  let row = updatetab.vaccinationstable.children.item(i);
  if (row.hasAttribute('name')) {
    vaccinations.rows.push({
      name: row.getAttribute('name'),
      statetd: row.children.item(1),
      input: row.children.item(2).firstElementChild
    });
  }
}
vaccinations.state.addEventListener('change', () => updateState(
  vaccinations.state, vaccinations.date
));
vaccinations.date.addEventListener('change', updateVaccinationsDate);
vaccinations.button.addEventListener('click', postVaccinations);
vaccinations.date.disabled = true;
vaccinations.button.disabled = true;

sel = updatetab.refreshtable.querySelector.bind(updatetab.refreshtable);
const refresh = {
  button: sel('button')
};
refresh.button.addEventListener('click', postRefresh);

const manage_div = elem('#management-tab');
sel = manage_div.querySelector.bind(manage_div);
const managetab = {
  div: manage_div,
  addtable: sel('table[id=add-district]').firstElementChild,
  updatetable: sel('table[id=update-district]').firstElementChild,
  deletetable: sel('table[id=delete-district]').firstElementChild
};

sel = managetab.addtable.querySelector.bind(managetab.addtable);
const adddistrict = {
  state: sel('select[name=state]'),
  district: sel('input[name=district]'),
  population: sel('input[name=population]'),
  button: sel('button')
};
adddistrict.state.addEventListener('change', () => updateState(
  adddistrict.state, undefined, adddistrict.district
));
adddistrict.district.addEventListener('change', () => {
  adddistrict.button.disabled = false;
});
adddistrict.button.addEventListener('click', postAddDistrict);
adddistrict.district.disabled = true;
adddistrict.button.disabled = true;

sel = managetab.updatetable.querySelector.bind(managetab.updatetable);
const updatedistrict = {
  state: sel('select[name=state]'),
  district: sel('select[name=olddistrict]'),
  newname: sel('input[name=newdistrict]'),
  button: sel('button')
};
updatedistrict.state.addEventListener('change', () => updateState(
  updatedistrict.state, updatedistrict.district, updatedistrict.district
));
updatedistrict.district.addEventListener('change', () => updateDistrict(
  updatedistrict.district, updatedistrict.newname
));
updatedistrict.newname.addEventListener('change', () => {
  updatedistrict.button.disabled = false;
});
updatedistrict.button.addEventListener('click', postUpdateDistrict);
updatedistrict.district.disabled = true;
updatedistrict.newname.disabled = true;
updatedistrict.button.disabled = true;

sel = managetab.deletetable.querySelector.bind(managetab.deletetable);
const deletedistrict = {
  state: sel('select[name=state]'),
  district: sel('select[name=district]'),
  button: sel('button')
};
deletedistrict.state.addEventListener('change', () => updateState(
  deletedistrict.state, deletedistrict.district, deletedistrict.district
));
deletedistrict.district.addEventListener('change', () => updateDistrict(
  deletedistrict.district, deletedistrict.button
));
deletedistrict.button.addEventListener('click', postDeleteDistrict);
deletedistrict.district.disabled = true;
deletedistrict.button.disabled = true;

switchTabs();
setupPage();

function switchTabs(event) {
  let checked = tabs.querySelector('input[type=radio]:checked').value;
  if (checked === 'update') {
	updatetab.div.style.display = 'block';
	managetab.div.style.display = 'none';
  } else {
	updatetab.div.style.display = 'none';
	managetab.div.style.display = 'block';
  }
}

function setupPage() {
  let stateDropdowns = [
    cases.state, vaccinations.state, adddistrict.state,
    updatedistrict.state, deletedistrict.state
  ];

  fetchget('/api/states/list', {}).then(
    response => response.json()
  ).then(
    data => {
      console.log(data);
      for (let i=0; i<data['state_id'].length; i++) {
        let opt = document.createElement('option');
        opt.textContent = data['state'][i];
        opt.value = data['state_id'][i];
        stateDropdowns.forEach((dropdown) => {
          dropdown.append(opt.cloneNode(true));
        });
      }
      stateDropdowns.forEach((dropdown) => {
        dropdown.selectedIndex = -1;
      });
    }
  );
}

function updateState(state, district, next) {
  if (state.selectedIndex == -1) {
    return;
  }
  if (district != undefined) {
    fetchget('/api/districts/list', {
      stateid: state.value
    }).then(
      response => response.json()
    ).then(
      data => {
        console.log(data);
        let options = Array();
        for (let i=0; i<data['districtid'].length; i++) {
          let opt = document.createElement('option');
          opt.textContent = data['Name'][i];
          opt.value = data['districtid'][i];
          options.push(opt);
        }
        district.replaceChildren(...options);
        district.selectedIndex = -1;
        district.disabled = false;
      }
    );
  }
  if (next != undefined)
    next.disabled = false;
}

function updateDistrict(district, next) {
  if (district.selectedIndex == -1) {
    return;
  }
  if (next != undefined)
    next.disabled = false;
}

function updateCasesDate() {
  if (cases.date.value == '') {
    cases.button.disabled = true;
    return;
  }
  fetchget('/api/states/values', {
    stateid: cases.state.value,
    date: cases.date.value
  }).then(
    response => response.json()
  ).then(
    data => {
      console.log(data);
      cases.rows.forEach((row) => {
        row.statetd.textContent = data[row.name];
      });
    }
  );
  fetchget('/api/districts/values', {
    districtid: cases.district.value,
    date: cases.date.value
  }).then(
    response => response.json()
  ).then(
    data => {
      console.log(data);
      cases.rows.forEach((row) => {
        if (data.hasOwnProperty(row.name)) {
          row.districttd.textContent = data[row.name];
        }
      });
    }
  );
  cases.button.disabled = false;
}

function postCases() {
  if (window.confirm('Are you sure you want to issue an update?')) {
    fetchpost('/api/update/newcases', {
      stateid: cases.state.value,
      districtid: cases.district.value,
      date: cases.date.value,
      confirmed: cases.rows[0].input.value,
      recovered: cases.rows[1].input.value,
      deceased: cases.rows[2].input.value,
      tested: cases.rows[3].input.value
    }).then(
      response => {
        if (response.ok) {
          window.alert('Update operation successful');
          updateCasesDate();
          return undefined;
        }
        return response.json();
      }
    ).then(
      data => {
        if (data == undefined)
          return;
        window.alert(data.error);
      }
    );
  }
}

function updateVaccinationsDate() {
  if (vaccinations.date.value == '') {
    vaccinations.button.disabled = true;
    return;
  }
  fetchget('/api/states/vaccinevalues', {
    stateid: vaccinations.state.value,
    date: vaccinations.date.value
  }).then(
    response => response.json()
  ).then(
    data => {
      console.log(data);
      vaccinations.rows.forEach((row) => {
        row.statetd.textContent = data[row.name];
      });
    }
  );
  vaccinations.button.disabled = false;
}

function postVaccinations() {
  if (window.confirm('Are you sure you want to issue an update?')) {
    fetchpost('/api/update/newvaccinations', {
      stateid: vaccinations.state.value,
      date: vaccinations.date.value,
      sessions: vaccinations.rows[0].input.value,
      indivregistered: vaccinations.rows[1].input.value,
      males: vaccinations.rows[2].input.value,
      females: vaccinations.rows[3].input.value,
      trans: vaccinations.rows[4].input.value,
      firstdose: vaccinations.rows[5].input.value,
      seconddose: vaccinations.rows[6].input.value,
      totaldose: vaccinations.rows[7].input.value,
      covaxin: vaccinations.rows[8].input.value,
      covishield: vaccinations.rows[9].input.value,
      sites: vaccinations.rows[10].input.value,
    }).then(
      response => {
        if (response.ok) {
          window.alert('Update operation successful');
          updateVaccinationsDate();
          return undefined;
        }
        return response.json();
      }
    ).then(
      data => {
        if (data == undefined)
          return;
        window.alert(data.error);
      }
    );
  }
}

function postRefresh() {
  if (window.confirm('Are you sure you want to refresh ' +
    'database? It may take some time.')) {
    fetchpost('/api/update/refreshfull', {}).then(
      response => {
        if (response.ok) {
          window.alert('Refresh successful');
          return undefined;
        }
        return response.json();
      }
    ).then(
      data => {
        if (data == undefined)
          return;
        window.alert(data.error);
      }
    );
  }
}

function postAddDistrict() {
  if (window.confirm('Are you sure you want to add this district?'))
  {
    fetchpost('/api/management/newdistrict', {
      stateid: adddistrict.state.value,
      districtname: adddistrict.district.value,
      population: adddistrict.population.value
    }).then(
      response => {
        if (response.ok) {
          window.alert('New district added successfully!');
          return undefined;
        }
        return response.json();
      }
    ).then(
      data => {
        if (data == undefined)
          return;
        window.alert(data.error);
      }
    );
  }
}

function postUpdateDistrict() {
  if (window.confirm('Are you sure you want to update this district?'))
  {
    fetchpost('/api/management/updatedistrict', {
      districtid: updatedistrict.district.value,
      newname: updatedistrict.newname.value
    }).then(
      response => {
        if (response.ok) {
          window.alert('District updated successfully!');
          return undefined;
        }
        return response.json();
      }
    ).then(
      data => {
        if (data == undefined)
          return;
        window.alert(data.error);
      }
    );
  }
}

function postDeleteDistrict() {
  if (window.confirm('Are you sure you want to delete this district?' +
    'All data corresponding to this district will be deleted! ' +
    'This process is irreversible.'))
  {
    fetchpost('/api/management/deletedistrict', {
      districtid: deletedistrict.district.value
    }).then(
      response => {
        if (response.ok) {
          window.alert('District deleted permanently.');
          return undefined;
        }
        return response.json();
      }
    ).then(
      data => {
        window.alert(data.error);
      }
    );
  }
}
