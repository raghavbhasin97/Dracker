
export const validateEmail = (email) => {
	return /^([a-zA-Z0-9_.]+@[a-zA-Z]+\.[a-zA-Z]{2,3})$/.test(email);
}

export const validatePassword = (pass) => {
	return /^[^\W]{5}[^\W]+$/.test(pass);
}