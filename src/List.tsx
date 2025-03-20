import { Item } from "./Item";

interface Props {
  items: Item[];
  removeItem: (id: number) => void;
}

function List({ items, removeItem }: Props) {
  return (
    <ul className="flex-center-column">
      {items.map((item) => (
        <li className="appended-item" key={item.id}>
          <p>{item.value}</p>
          <button className="icon-button" onClick={() => removeItem(item.id)}><span className="material-icons">delete</span></button>
        </li>
      ))}
    </ul>
  );
}

export default List;
