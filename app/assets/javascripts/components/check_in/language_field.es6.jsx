class LanguageField extends React.Component {
  constructor(props) {
    super(props);

    this.state = {showOther: this.isOther(this.props.language)};
  }
  isOther(language) {
    return (language != 'english' && language != 'spanish' && 
            language != null && language != '')
  }
  onChange(e) {
    let value = e.target.value;

    this.setState({showOther: value == 'other'});
  }
  render() {
    let otherLanguageField,
        defaultSelected = this.props.language;

    if(this.isOther(defaultSelected)){
      defaultSelected = 'other';
    }

    if(this.state.showOther) {
      let otherValue;

      if(defaultSelected == 'other') {
        otherValue = this.props.language;
      }

      otherLanguageField = (
        <div className='row'>
          <span className='label'>
            <label htmlFor='patient_language_other'>Other Language</label>
          </span>
          <span className='formw'>
            <input type='text' name='patient[language]'
              id='patient_language_other' required='true'
              defaultValue={otherValue} />
          </span>
        </div>
      )
    }

    return (
      <div>
        <div className='row'>
          <span className='label'>
            <label htmlFor='patient_language'>Language</label>
          </span>
          <span className='formw'>
            <select name='patient[language]' id='patient_language'
              onChange={this.onChange.bind(this)}
              required='true' defaultValue={defaultSelected}>
              <option></option>
              <option value='english'>English</option>
              <option value='spanish'>Spanish</option>
              <option value='other'>Other</option>
            </select>
          </span>
        </div>
        {otherLanguageField}
      </div>
    )
  }
}
