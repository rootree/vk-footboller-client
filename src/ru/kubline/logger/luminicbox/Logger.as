package ru.kubline.logger.luminicbox {

    import flash.utils.getQualifiedClassName;

    /**
     * создает просто консольный логер
     * @autor denis
     */
    public class Logger extends LuminicLogger {
        public function Logger(clazz:Class) {
            super(getQualifiedClassName(clazz));
            addPublisher( new ConsolePublisher() );
            setLevel(Level.LOG);
        }
    }
}