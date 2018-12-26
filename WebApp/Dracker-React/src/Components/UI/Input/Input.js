import React, { Component } from 'react';
import classes from './Input.css'


class Input extends Component {

	state = {}

	constructor(props) {
	  super(props);
	  this.state = {
	  				valid: props.valid, 
	  				empty: true, 
	  				type: this.props.type, 
	  				showText: this.props.type === 'password' ? 'Show'  : null
	  };
	}

	focussedOut = (event) => {
		const value = event.target.value
		if(this.props.required) {
			if(!this.props.validation(value)) {
				this.setState({valid: false, empty: value.length < 1})
			} else {
				this.setState({valid: true})
			}
		}
	}

	valueChanged = (event) => {
		const value = event.target.value
		if(this.props.required) {
			if(value.length > 0) {
				this.setState({valid: true, empty: false})
			} else {
				this.setState({valid: false, empty: true})
			}
		}
	}

	componentWillReceiveProps(props) {
	 	this.setState({valid: props.valid})
	}

	showHandler = () => {
		 switch(this.state.type) {
		 	case 'text':
		 		this.setState({type: 'password', showText: 'Show'})
		 		break;
		 	case 'password':
		 		this.setState({type: 'text', showText: 'Hide'})
		 		break;
		 	default: 
		 		this.setState({type: 'password', showText: 'Show'})
		 }
	}

	render() {
		let labelClasses = [classes.Label];
		let validityMessage = null;
		let inputClasses = [classes.Text];
		if(!this.state.valid) {
			labelClasses.push(classes.InvalidLabel);
			let message = this.props.invalidMessage;
			if(this.state.empty) {
				message = "This is a required field."
				inputClasses.push(classes.InvalidLabel)
			}
			validityMessage = (
					<div className={classes.Validity}>
						{message}
					</div>
			);
		}

		let showView = null;
		if(this.props.type === "password") {
			inputClasses.push(classes.Password)
			showView = (
				<div className={classes.Show} onClick={this.showHandler}>
					{this.state.showText}
				</div>
			);
		}

		return(
			<div className={classes.Input}>
				<label className={labelClasses.join(' ')}>
					{this.props.label}
				</label>
				<div className={classes.InputContainer}>
					<input 
						className = {inputClasses.join(' ')}
						type = {this.state.type}
						id = {this.props.id}
						name = {this.props.name}
						autoCapitalize = {this.props.autoCapitalize}
						onBlur = {(event) => this.focussedOut(event)}
						onChange = {(event) => this.valueChanged(event)}
					/>
					{showView}
				</div>
				{validityMessage}

			</div>
		);
	}
}


export default Input;