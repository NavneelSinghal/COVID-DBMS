function fetchget(api, params) {
  let urlparams = new URLSearchParams(params);
  return fetch(`${api}?${urlparams.toString()}`, {
	method: 'GET',
	headers: {
	  'Content-Type': 'application/x-www-form-urlencoded'
	}
  });
}

function debugflask(api, params) {
  fetchget(api, params).then(
	response => {
	  if (response.ok) {
		return response.text();
	  }
	  return undefined;
	}
  ).then(
	blob => {
	  if (blob == undefined) {
		console.log('Flask returned error (HTTP status code != 200)')
	  } else {
		console.log(blob);
	  }
	}
  );
}


