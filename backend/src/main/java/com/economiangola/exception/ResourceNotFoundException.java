// src/main/java/com/economiangola/exception/ResourceNotFoundException.java
package com.economiangola.exception;

public class ResourceNotFoundException extends RuntimeException {

    public ResourceNotFoundException(String message) {
        super(message);
    }

    public ResourceNotFoundException(String recurso, String campo, Object valor) {
        super(String.format("%s não encontrado com %s: '%s'", recurso, campo, valor));
    }
}
