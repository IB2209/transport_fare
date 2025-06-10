
export function definitionsFromContext(context) {
  return context.keys()
    .filter((key) => key.endsWith("_controller.js"))
    .map((key) => {
      const identifier = key
        .replace(/^.*\/(controllers\/)?/, "")
        .replace(/_controller\.js$/, "")
        .replace(/\//g, "--");
      return { identifier, controllerConstructor: context(key).default };
    });
}