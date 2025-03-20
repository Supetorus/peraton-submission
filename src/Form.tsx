import { Item, generateId } from "./Item";

interface Props {
  buttonText: string;
  onSubmit: (input: Item) => void;
}

function Form({ buttonText, onSubmit }: Props) {
  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const formData = new FormData(event.currentTarget);
    const userInput = formData.get("userInput") as string;
    if (userInput === "") return;
    onSubmit({value: userInput, id: generateId()});
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
      <button className="text-button" type="submit">{buttonText}</button>
    </form>
  );
}

export default Form;
