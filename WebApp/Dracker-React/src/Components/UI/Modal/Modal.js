import React, { Component } from 'react';
import classes from './Modal.css'
import Aux from '../../../hoc/Aux/Aux'
import Backdrop from '../Backdrop/Backdrop'


class Modal extends Component {

	shouldComponentUpdate(nextProps, nextState) {
		return nextProps.show !== this.props.show || nextProps.children !== this.props.children;
	}

	render() {
		const props = this.props
		return(
				<Aux>
					<Backdrop show={props.show} clicked={props.clicked} />
					<div className={classes.Modal} style={{
						transform: props.show ? 'translateY(0)' : 'translateY(-100%)',
						opacity:  props.show ? '1' : '0'
					}}>
						{props.children}
					</div>
				</Aux>
		);
	}
}


export default Modal;