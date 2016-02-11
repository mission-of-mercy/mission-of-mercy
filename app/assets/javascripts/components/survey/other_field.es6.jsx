class SurveyOtherField extends React.Component {
  constructor(props) {
    super(props);

    this.state = {showTextField: props.otherPresent}
  }
  toggleTextField() {
    this.setState({showTextField: !this.state.showTextField})
  }
  render(){
    let textField;

    if(this.state.showTextField) {
      textField = (
        <input type='text' name={this.props.fieldName}
          defaultValue={this.props.other} placeholder='Please describe'
          className='survey--other-field' />
      )
    }
    return (
      <div>
        <label>
          <input type='checkbox' onChange={this.toggleTextField.bind(this)}
          checked={this.state.showTextField} /> Other
        </label>
        {textField}
      </div>
    )
  }
}
