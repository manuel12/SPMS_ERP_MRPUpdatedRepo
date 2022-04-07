import React from "react";
import logo from './logo.svg';
import './App.css';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import Button from '@material-ui/core/Button';
import AddIcon from '@material-ui/icons/Add';
import Icon from '@material-ui/core/Icon';
import DeleteIcon from '@material-ui/icons/Delete';
import NavigationIcon from '@material-ui/icons/Navigation';

  constructor() {
    super()

    this.state = {
      user: false,
      addForm: false,
      employee: []
    }
  }

  email(str) {
    const email = str.target.value;
    this.setState({
      email: email
    });
  }

  password(str) {
    const password = str.target.value;
    this.setState({
      password: password
    });
  }

  formName(a) {
    this.setState({
      employeeName: a.target.value
    });
  }
  formEmail(a) {

    this.setState({
      employeeEmail: a.target.value
    });
  }
  formAddress(a) {
    this.setState({
      employeeAddress: a.target.value
    });
  }

  formPosition(a) {
    this.setState({
      employeePostion: a.target.value
    });
  }

  addEmployees() {
    const { employeeName, employeeAddress, employeeEmail, employeePostion, employee } = this.state;

    employee.push({
      employeeName: employeeName,
      employeeAddress: employeeAddress,
      employeeEmail: employeeEmail,
      employeePostion: employeePostion,

    });

    this.setState({
      employee,
      employeeName: "",
      employeeAddress: "",
      employeeEmail: "",
      employeePostion: "",
      addForm: false
    });
  }
/*
  logout() {
    this.setState({
      addForm: false,
      user: false,
      users: []
    });
  }
*/
/*  renderLogin() {
    return (
      <div className="login">
        <div className="loginHeader">
          <h1>LOGIN</h1>
        </div>
        <hr></hr>

        <div className="loginMain">

          <input type="email" placeholder="Enter Your Email" onChange={this.email.bind(this)}></input>
          <br></br>
          <input type="password" placeholder="Enter Your Password" onChange={this.password.bind(this)} ></input>
          <br></br>
          <button onClick={() => {
            const email = this.state.email
            const password = this.state.password

            if (email === "domain@domain.com" && password == "domain") {

              swal("Login Succesful", "You Have Sucessfully Logged In", "success");
              this.setState({ user: true });

            }
            else {
              swal("Login Failed", "Please Check Your Login Details", "error");
            }
          }}>LOGIN</button>
        </div>
      </div>
    );
  }
*/

  showTable() {
    const { employee } = this.state;

    return (
      <div className="employee">
        <div className="employeeHeader">
          <h1>Employee Details</h1>
          <button onClick={() => this.setState({ addForm: true })}> Add Employee</button>
          <button onClick={this.logout.bind(this)}> logout</button>
        </div>

        <table class="table" border="1px">
          <thead>
            <tr>
              <th>Email</th>
              <th>Name</th>
              <th>Address</th>
              <th>Position</th>
            </tr>
          </thead>
          <tbody>
            {employee.map((user, index) => {
              return (
                <tr>
                  <td>{user.employeeEmail}</td>
                  <td>{user.employeeName}</td>
                  <td>{user.employeeAddress}</td>
                  <td>{user.employeePostion}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    );
  }

  addEmployeeForm() {

    return (
      <div className="employee form">
        <h1>Add Emoployee Form</h1>

        <input type="email" placeholder=" Email" onChange={this.formEmail.bind(this)}></input>
        <br></br>
        <input type="text" placeholder="Name" onChange={this.formName.bind(this)}></input>
        <br></br>
        <input type="text" placeholder="Address" onChange={this.formAddress.bind(this)}></input>
        <br></br>
        <input type="text" placeholder="Position" onChange={this.formPosition.bind(this)}></input>
        <button onClick={this.addEmployees.bind(this)}>Add Employee</button>
        
      </div>
    );
  }

  addtext() {
    var text = this.state.text
    const obj = { text, date: new Date() }
    console.log(obj)
  }

  render() {
    const { user, addForm } = this.state

    return (
      <div className="App">
        {!user && this.renderLogin()}
        {user && !addForm && this.showTable()}
        {user && addForm && this.addEmployeeForm()}


      </div>
    );
  }
}

/*const EmployeeCreate = () => {
  return (
    <div>
      <h1>Create a new employee</h1>
    </div>
  );
};
*/

export default EmployeeCreate;
