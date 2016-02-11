class SurveyResponseTypePrompt extends React.Component {
  constructor(props){
    super(props);

    this.state = {responseType: props.responseType};
  }
  componentDidMount() {
    if(this.state.responseType != null) {
      this.showQuestions();
    }
  }
  showQuestions(type) {
    jQuery('#survey--sensative-questions').show();
    if(type != undefined)
      this.setState({responseType: type});
  }
  render() {
    let responseType = this.state.responseType;

    if(responseType == null) {
      return (
        <div className='survey--prompt'>
          <h2>
            Would you like to answer the next set of questions verbally or in
            written form?
          </h2>
          <a onClick={this.showQuestions.bind(this, 'verbal')}
            className='btn btn-large'>Verbally</a>
          <a onClick={this.showQuestions.bind(this, 'written')}
            className='btn btn-large'>Written</a>
        </div>
      )
    } else {
      return (
        <input type='hidden' name='survey[response_type]' value={responseType} />
      )
    }
  }
}
