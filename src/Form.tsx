interface Props {
  buttonText: string;
  onSubmit: (input: string) => void;
}

function Form({ buttonText, onSubmit }: Props) {
  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const formData = new FormData(event.currentTarget);
    onSubmit(formData.get("userInput") as string);
    (event.target as HTMLFormElement).reset();
  };

  return (
    <form
      id="myForm"
      className="flex-center-column full-width"
      onSubmit={handleSubmit}
    >
      <input
        type="text"
        id="userInput"
        name="userInput"
        className="space-below"
      />
      <button type="submit">{buttonText}</button>
    </form>
  );
}

export default Form;
