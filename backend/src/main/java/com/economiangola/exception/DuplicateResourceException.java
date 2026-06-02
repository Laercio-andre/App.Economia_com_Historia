// src/main/java/com/economiangola/exception/DuplicateResourceException.java
package com.economiangola.exception;

public class DuplicateResourceException extends RuntimeException {

    public DuplicateResourceException(String message) {
        super(message);
    }

    public DuplicateResourceException(String recurso, String campo, Object valor) {
        super(String.format("%s já existe com %s: '%s'", recurso, campo, valor));
    }
}
