
export const validateEmail = (email) => {
	return /^([a-zA-Z0-9_.]+@[a-zA-Z]+\.[a-zA-Z]{2,3})$/.test(email);
}

export const validatePassword = (pass) => {
	return /^[\S]{5}[\S]+$/.test(pass);
}

export const validatePhone = (phone) => {
	return /^\d{10}$/.test(phone);
}

export const validateName = (name) => {
	return /^\w+ \w+$/.test(name);
}

export const validateStreet = (street) => {
	return street.length > 5;
}

export const validateCity = (city) => {
	return /^[a-zA-Z]+(?:[\s-][a-zA-Z]+)*$/.test(city)
}

export const validateZip = (zip) => {
	return /^\d{5}$/.test(zip);
}

export const validateSSN = (ssn) => {
	return /^\d{4}$/.test(ssn);
}

export const validateBirthdate = (date) => {
	const birthday = new Date(date)
	const ageDifMs = Date.now() - birthday.getTime();
    const ageDate = new Date(ageDifMs); 
    const age = Math.abs(ageDate.getUTCFullYear() - 1970);
	return age >= 18;
}