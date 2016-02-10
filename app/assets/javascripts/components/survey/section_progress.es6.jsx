class SectionProgress extends React.Component {
  constructor(props) {
    super(props);

    this.state = {completed: 0}
  }
  componentDidMount() {
    let group = this.props.group,
        inputs = jQuery(`div[data-group=${group}] :input`);

    debugger;
  }
  render(){
    return (
      <div className='survey--section-progress'>
        {this.state.completed} out of {this.props.questions} completed
      </div>
    )
  }
}
