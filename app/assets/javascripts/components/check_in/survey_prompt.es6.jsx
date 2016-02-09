class SurveyPrompt extends React.Component {
  showQuestions() {
    jQuery('#survey--sensative-questions').show();
    jQuery(ReactDOM.findDOMNode(this)).hide();
  }
  render() {
    return (
      <div className='survey--prompt'>
        <h2>
          Would you like to answer the next set of questions verbally or in
          written form?
        </h2>
        <a onClick={this.showQuestions.bind(this)}
          className='btn btn-large'>Verbally</a>
        <a onClick={this.showQuestions.bind(this)}
          className='btn btn-large'>Written</a>
      </div>
    )
  }
}
