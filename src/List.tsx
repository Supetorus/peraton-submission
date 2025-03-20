function List({ items }: { items: string[] }) {
  return (
    <>
      {items.map((item) => (
        <p className="appended-item">{item}</p>
      ))}
    </>
  );
}

export default List;
