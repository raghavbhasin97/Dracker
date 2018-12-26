
String.prototype.replaceAll = function(search, replacement) {
    var target = this;
    return target.replace(new RegExp(search, 'g'), replacement);
};

export const formatPhone = (phone) => {
	return phone.replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3');
}

export const formatDate = (dateString) =>  {
  var date = new Date(dateString);
  var locale = "en-us", month = date.toLocaleString(locale, { month: "long" });
  var day = date.getDate();
  var year = date.getFullYear();
  var hours = date.getHours();
  var minutes = date.getMinutes();
  var timeOfDay = "AM";
  if(hours > 12) {
  	timeOfDay = "PM";
  	hours -= 12;
  }
  return month + " " + day + ", " + year + ", " + hours + ":" + minutes + " " + timeOfDay;
}

export const getProfile = (uid) => {
	return "https://s3.amazonaws.com/drackerprofiles/".concat(uid);
}

export const getTransactionImage = (imageID) => {
	return "https://s3.amazonaws.com/drackerimages/".concat(imageID);
}

export const getIdentifier = (url) => {
  return url.substring(url.lastIndexOf("/") + 1);
}

export const getLogo = (institution) => {
  const inst = institution.replaceAll(' ', '').toLowerCase();
  return 'https://logo.clearbit.com/' + inst + '.com?size=150';
}