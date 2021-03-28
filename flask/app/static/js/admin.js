const elem = document.querySelector.bind(document);
let sel = undefined;

const tabs = elem('#tabs');
tabs.addEventListener('click', switchTabs);

const update_div = elem('#update-tab');
sel = update_div.querySelector.bind(update_div);
const updatetab = {
  div: update_div,
  casestable: sel('table[id=update-cases]'),
  vaccinationstable: sel('table[id=update-vaccinations]')
};

const manage_div = elem('#management-tab');
sel = manage_div.querySelector.bind(manage_div);
const managetab = {
  div: manage_div,
  addtable: sel('table[id=add-district]'),
  updatetable: sel('table[id=update-district]'),
  deletetable: sel('table[id=delete-distrct]')
};

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

switchTabs();
